<style>
  /* vars defined in public/assets/global.css */
  h1 {
    font-size: 1.25em;
  }
  p {
    margin: 0.5rem 0;
  }
</style>

<script>
  import { LayerCake, Svg, flatten, calcExtents, uniques } from "layercake";
  import { min, range, sum, ascending } from "d3-array";
  import { nest } from "d3-collection";
  import { format } from "d3-format";
  import { scaleBand } from "d3-scale";
  import ByCounty from "./ByCounty.svelte";
  import BerkshireVsMa from "./BerkshireVsMa.svelte";
  import MaDeath from "./MaDeath.svelte";
  import population from "../data/population-ma.csv";
  import maData from "../data/ma.csv";

  const MS_IN_DAY = 86400000;
  const MONTHS = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  let xDomain;

  $: cleanData = maData ? clean(maData) : [];
  $: countyData = byCounty(cleanData);
  $: flatData = flatten(countyData.map(d => d.value));
  $: berkshireData = countyData.find(d => d.key === "Berkshire");
  $: stateData = { key: "Mass.", value: rollup(countyData) };
  $: otherData = {
    key: "Rest of Mass.",
    value: rollup(countyData, "Berkshire")
  };

  $: xScale = scaleBand().padding(0.1);
  $: {
    const u = uniques(flatData.map(d => d.date)).map(d => new Date(d));
    u.sort(ascending);
    xDomain = u;
  }

  function formatTickX(d) {
    return `${MONTHS[d.getUTCMonth()]} ${d.getUTCDate()}`;
  }

  function perCapita(v, d) {
    const m = population.find(p => p.county === d.county);
    if (m) return (+d[v] / +m.population) * 1000;
    return null;
  }

  function byCounty(data) {
    return nest()
      .key(d => d.county)
      .rollup(values => {
        values.sort((a, b) => ascending(a.dateF, b.dateF));
        const withNew = values.map((v, i) => {
          const casesNew = i > 0 ? v.cases - values[i - 1].cases : 0;
          const deathsNew = i > 0 ? v.deaths - values[i - 1].deaths : 0;
          return {
            ...v,
            index: i,
            casesNew,
            deathsNew
          };
        });
        const withCapita = withNew.map(d => ({
          ...d,
          casesNewCapita: perCapita("casesNew", d),
          deathsNewCapita: perCapita("deathsNew", d)
        }));
        return withCapita;
      })
      .entries(data);
  }

  function rollup(data, exclude = []) {
    const flat = flatten(data.map(d => d.value));
    const entries = flat.filter(d => !exclude.includes(d.county));
    const counties = uniques(entries.map(d => d.county));
    const pop = sum(counties, c => {
      const m = population.find(p => p.county === c);
      return m ? +m.population : 0;
    });

    return nest()
      .key(d => d.dateF)
      .rollup(values => {
        const cases = sum(values, v => v.cases);
        const deaths = sum(values, v => v.deaths);
        const casesNew = sum(values, v => v.casesNew);
        const deathsNew = sum(values, v => v.deathsNew);
        const casesCapita = (cases / pop) * 1000;
        const deathsCapita = (deaths / pop) * 1000;
        const casesNewCapita = (casesNew / pop) * 1000;
        const deathsNewCapita = (deathsNew / pop) * 1000;
        return {
          date: values[0].date,
          dayIndex: values[0].dayIndex,
          dateF: values[0].dateF,
          cases,
          deaths,
          casesCapita,
          deathsCapita,
          casesNew,
          deathsNew,
          casesNewCapita,
          deathsNewCapita
        };
      })
      .entries(entries)
      .map(d => d.value);
  }

  function clean(raw) {
    const march = new Date("2020-03-01");
    const c = raw
      .map(d => ({
        ...d,
        cases: +d.cases,
        deaths: +d.deaths,
        casesCapita: perCapita("cases", d),
        deathsCapita: perCapita("deaths", d),
        dateF: new Date(d.date)
      }))
      .filter(v => v.dateF - march >= 0);

    const start = min(c, d => d.dateF);

    return c.map(d => ({
      ...d,
      dayIndex: Math.floor((d.dateF - start) / MS_IN_DAY)
    }));
  }
</script>

<BerkshireVsMa data="{[otherData, berkshireData]}" {xScale} {formatTickX} />

<ByCounty data="{countyData}" {xScale} {xDomain} {formatTickX} />

<MaDeath data="{stateData.value}" {xScale} {xDomain} {formatTickX} />

<p class="center">
  Data source:
  <a
    target="_blank"
    href="https://www.nytimes.com/interactive/2020/us/coronavirus-us-cases.html">
    New York Times
  </a>
</p>
<p class="center">
  By
  <a target="_blank" href="https://twitter.com/codenberg">Russell Goldenberg</a>
</p>
