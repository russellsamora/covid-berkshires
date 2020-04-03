<style>
  .charts {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    margin-bottom: 3rem;
  }
  .chart {
    margin: 1rem 0;
    width: 50%;
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
  h5 {
    margin: 0;
    color: var(--black);
  }
  .Berkshire {
    color: var(--highlightText);
  }
  .choose {
    display: flex;
    justify-content: center;
    flex-direction: column;
    user-select: none;
    margin-bottom: 1rem;
    width: 100%;
  }
  .a,
  .b {
    width: 100%;
    padding: 0.25rem 0;
    text-align: center;
    display: flex;
    justify-content: center;
  }
  button {
    margin: 0 0.25em;
  }
  .a button {
    width: 5rem;
  }
  .b button {
    width: 10rem;
  }

  @media only screen and (min-width: 700px) {
    .chart {
      width: 25%;
    }
  }
  @media only screen and (min-width: 900px) {
    .chart {
      width: 20%;
    }
  }
  @media only screen and (min-width: 1100px) {
    .chart {
      width: 16.25%;
    }
  }
  @media only screen and (min-width: 1300px) {
    .chart {
      width: 13.33%;
    }
  }
</style>

<script>
  import Bar from "./Bar.svelte";
  import AxisX from "./AxisX.svelte";
  import AxisY from "./AxisY.svelte";
  import PeakLabel from "./PeakLabel.svelte";
  import {
    LayerCake,
    Svg,
    Html,
    flatten,
    calcExtents,
    uniques
  } from "layercake";
  import { descending } from "d3-array";
  import { format } from "d3-format";

  export let data;
  export let xScale;
  export let xDomain;
  export let formatTickX;

  const PAD = 8;
  const RATIO = 3;

  let padding = { top: PAD * 3, right: PAD, bottom: PAD * 3, left: PAD };
  let chartW;
  let visible;
  let setting = ["cases", "Capita"];
  let classA = true;
  let classB = true;

  $: toggle = setting.join("");
  $: flatData = flatten(data.map(d => d.value));
  $: extents = calcExtents(flatData, fields);

  $: fields = [
    { field: "x", accessor: d => d.index },
    { field: "y", accessor: d => d[toggle] }
  ];

  $: chartH = Math.max(120, Math.floor(chartW / RATIO));
  $: visible = !!chartW;
  $: yDomain = [0, extents.y[1]];

  $: if (data) {
    data.sort((a, b) =>
      descending(
        a.value[a.value.length - 1][toggle],
        b.value[b.value.length - 1][toggle]
      )
    );
    data = data;
  }

  function formatTickY(d) {
    if (toggle.includes("Capita")) return format(".02f")(d);
    return format(",")(d);
  }
  function change() {
    if (this.classList[0] !== "active") {
      const { a, b } = this.dataset;

      if (typeof a !== "undefined") {
        setting[0] = a;
        classA = !classA;
      }
      if (typeof b !== "undefined") {
        setting[1] = b;
        classB = !classB;
      }
      setting = setting;
    }
  }
</script>

<div class="charts" class:visible>
  <h3>Covid-19 cases by county in Massachusetts</h3>
  <div class="choose">
    <div class="a">
      <button class:active="{classA}" on:click="{change}" data-a="cases">
        Cases
      </button>
      <button class:active="{!classA}" on:click="{change}" data-a="deaths">
        Deaths
      </button>
    </div>
    <div class="b">
      <button class:active="{classB}" on:click="{change}" data-b="Capita">
        Population Adjusted
      </button>
      <button class:active="{!classB}" on:click="{change}" data-b="">
        Raw Numbers
      </button>
    </div>
  </div>
  {#each data.filter(d => d.key !== 'Unknown') as { key, value }, i (key)}
    <div class="chart">
      <h5 class="center {key}">{key}</h5>
      <figure
        class:visible
        style="height: {chartH}px;"
        bind:clientWidth="{chartW}">
        {#if visible}
          <LayerCake
            {xScale}
            {xDomain}
            {yDomain}
            {padding}
            x="dateF"
            y="{toggle}"
            data="{value}">
            <Svg>
              <AxisX
                ticks="{[xDomain[0], xDomain[xDomain.length - 1]]}"
                formatTick="{formatTickX}"
                bar="{true}" />
              <AxisY baseline="true" />
              <Bar {toggle} {key} />
            </Svg>
            <Html>
              <PeakLabel {key} {toggle} {formatTickY} {i} />
            </Html>
          </LayerCake>
        {/if}
      </figure>
    </div>
  {/each}
</div>
