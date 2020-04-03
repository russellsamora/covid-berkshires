<style>
  path {
    stroke: #666;
    stroke-width: 2px;
    fill: none;
  }
  .Berkshire {
    stroke: var(--highlight);
    stroke-width: 3px;
  }
</style>

<script>
  import { getContext } from "svelte";
  import { line, curveMonotoneX } from "d3-shape";
  const { data, xGet, yGet, xScale, width, height } = getContext("LayerCake");

  export let toggle;
  $: {
    // console.log($data[0].value[0]);
    // console.log($xGet($data[0].value[0]));
  }
  $: path = line()
    .x($xGet)
    .y($yGet)
    .curve(curveMonotoneX);
</script>

{#each $data as d (d.key)}
  <g class="location">
    <path class="{toggle} {d.key}" d="{path(d.value)}"></path>
  </g>
{/each}
