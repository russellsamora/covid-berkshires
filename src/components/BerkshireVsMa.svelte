<style>
  .chart {
    margin: 1rem auto;
    width: 100%;
    max-width: var(--maxWidth);
    user-select: none;
  }
  figure {
    padding: 0 1rem;
    display: block;
    margin: 0;
    visibility: hidden;
  }
  figure.visible {
    visibility: visible;
  }
  .choose {
    display: flex;
    justify-content: center;
    user-select: none;
  }
  button {
    margin: 0 0.25em;
    width: 5rem;
  }
</style>

<script>
  import Line from "./Line.svelte";
  import LineLabel from "./LineLabel.svelte";
  import AxisY from "./AxisY.svelte";
  import AxisX from "./AxisX.svelte";
  import {
    LayerCake,
    Svg,
    Html,
    flatten,
    calcExtents,
    uniques
  } from "layercake";
  import { ascending, descending } from "d3-array";
  import { format } from "d3-format";

  export let data;
  export let xScale;
  export let formatTickX;

  const PAD = 8;
  const RATIO = 3;
  const START = new Date("2020-03-07");

  let padding = { top: PAD, right: PAD, bottom: PAD * 3, left: PAD };
  let chartW;
  let visible;
  let setting = "deaths";
  let classA = false;
  let xDomain;

  $: toggle = `${setting}Capita`;
  $: flatData = flatten(data.map(d => d.value));
  $: extents = calcExtents(flatData, fields);

  $: fields = [
    { field: "x", accessor: d => d.index },
    { field: "y", accessor: d => d[toggle] }
  ];

  $: chartH = Math.max(120, Math.floor(chartW / RATIO));
  $: visible = !!chartW;
  $: yDomain = [0, extents.y[1]];

  $: {
    const u = uniques(flatData.map(d => d.date))
      .map(d => new Date(d))
      .filter(d => d >= START);
    u.sort(ascending);
    xDomain = u;
  }

  $: chartData = data.map(d => ({
    ...d,
    value: d.value.filter(v => v.dateF >= START)
  }));

  function formatTickY(d) {
    return format(`.0${toggle === "deathsCapita" ? "2" : "1"}f`)(d);
  }
  function change() {
    if (this.classList[0] !== "active") {
      const { a } = this.dataset;

      if (typeof a !== "undefined") {
        setting = a;
        classA = !classA;
      }
      setting = setting;
    }
  }
</script>

<div class="chart" class:visible>

  <h3 class="center">Covid-19 cases in Massachusetts</h3>
  <div class="choose">
    <button class:active="{classA}" on:click="{change}" data-a="cases">
      Cases
    </button>
    <button class:active="{!classA}" on:click="{change}" data-a="deaths">
      Deaths
    </button>
  </div>
  <figure class:visible style="height: {chartH}px;" bind:clientWidth="{chartW}">
    {#if visible}
      <LayerCake
        {xScale}
        {xDomain}
        {yDomain}
        {padding}
        x="dateF"
        y="{toggle}"
        data="{chartData}">
        <Svg>
          <AxisX
            ticks="{[xDomain[0], xDomain[xDomain.length - 1]]}"
            formatTick="{formatTickX}" />
          <AxisY
            tickNumber="{4}"
            formatTick="{formatTickY}"
            suffix="{` ${setting} per 1,000 residents`}" />
          <Line {toggle} />
        </Svg>
        <Html>
          <LineLabel />
        </Html>
      </LayerCake>
    {/if}
  </figure>
</div>
