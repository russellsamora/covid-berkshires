<style>
  circle {
    fill: white;
    stroke: black;
    stroke-width: 2px;
  }
</style>

<script>
  import { getContext } from "svelte";

  const { data, xGet, yGet } = getContext("LayerCake");

  export let r = 5;
</script>

<g class="states">
  {#each $data as d}
    <g class="state" transform="translate({$xGet(d)}, {$yGet(d)})">
      <text text-anchor="middle" y="-{r * 2}">{d.code}</text>
      <circle cx="0" cy="0" {r}></circle>
    </g>
  {/each}
</g>
