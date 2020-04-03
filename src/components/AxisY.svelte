<style>
  .tick {
    user-select: none;
  }

  line,
  .tick line {
    stroke: #ddd;
  }

  .tick text {
    fill: #666;
    font-weight: 400;
    font-size: 11px;
  }

  .baseline {
    stroke-dasharray: 0;
  }

  .tick:first-of-type line {
    /* display: none; */
  }
</style>

<script>
  import { getContext } from "svelte";

  const { width, height, xScale, yScale, padding } = getContext("LayerCake");

  export let gridlines = true;
  export let formatTick = d => d;
  export let ticks = undefined;
  export let tickNumber = undefined;
  export let baseline = false;
  export let suffix = "";

  $: tickVals = ticks || $yScale.ticks(tickNumber);
</script>

<g class="axis y-axis">
  {#if baseline}
    <line
      y1="{$height}"
      y2="{$height}"
      x1="0"
      x2="{$width - $padding.right}"></line>
  {:else}
    {#each tickVals as tick, i}
      <g
        class="tick tick-{tick}"
        transform="translate({$xScale.range()[0]},{$yScale(tick)})">
        {#if gridlines !== false}
          <line y1="0" y2="0" x1="0" x2="{$width - $padding.right}"></line>
        {/if}
        <text y="-6" x="0" text-anchor="start">
          {formatTick(tick)} {i === tickVals.length - 1 ? suffix : ''}
        </text>
      </g>
    {/each}
  {/if}
</g>
