<style>
  .tick {
    user-select: none;
  }

  line,
  .tick line {
    stroke: #aaa;
  }

  .tick text {
    fill: #666;
    font-weight: 400;
    font-size: 11px;
  }

  .baseline {
    stroke-dasharray: 0;
  }
</style>

<script>
  import { getContext } from "svelte";

  const { width, height, xScale, yScale } = getContext("LayerCake");

  export let formatTick = d => d;
  export let ticks = undefined;
  export let tickNumber = undefined;
  export let bar = false;

  $: tickVals = ticks || $xScale.ticks(tickNumber);
</script>

<g class="axis x-axis">
  {#each tickVals as tick, i}
    <g
      class="tick tick-{tick}"
      transform="translate({$xScale(tick)},{$yScale.range()[0] + 16})">
      <text
        y="0"
        x="{i === 0 ? 0 : bar ? $xScale.bandwidth() : 0}"
        text-anchor="{i === 0 ? 'start' : 'end'}">
        {formatTick(tick)}
      </text>
    </g>
  {/each}
</g>
