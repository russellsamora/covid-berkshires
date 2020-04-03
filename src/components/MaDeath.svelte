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
  let classA = true;
  let classB = true;
  let toggle = "deathsNew";

  $: flatData = data;
  $: extents = calcExtents(flatData, fields);
  $: fields = [
    { field: "x", accessor: d => d.dayIndex },
    { field: "y", accessor: d => d[toggle] }
  ];

  $: chartH = Math.max(120, Math.floor(chartW / RATIO));
  $: visible = !!chartW;
  $: yDomain = [0, extents.y[1]];

  function formatTickY(d) {
    return format(",")(d);
  }
</script>

<div class="chart" class:visible>
  <h3>Reported deaths each day in Massachusetts</h3>
  <figure class:visible style="height: {chartH}px;" bind:clientWidth="{chartW}">
    {#if visible}
      <LayerCake
        {xScale}
        {xDomain}
        {yDomain}
        {padding}
        x="dateF"
        y="{toggle}"
        {data}>
        <Svg>
          <AxisX
            ticks="{[xDomain[0], xDomain[xDomain.length - 1]]}"
            formatTick="{formatTickX}"
            bar="{true}" />
          <AxisY tickNumber="{4}" formatTick="{formatTickY}" />
          <Bar {toggle} key="Mass." />
        </Svg>
        <Html>
          <PeakLabel key="Mass." {toggle} {formatTickY} />
        </Html>
      </LayerCake>
    {/if}
  </figure>
</div>
