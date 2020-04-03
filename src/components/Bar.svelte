<style>
  rect {
    fill: #666;
  }
  .Berkshire {
    fill: var(--highlight);
  }
</style>

<script>
  import { getContext } from "svelte";
  const { data, xGet, yGet, xScale, width, height } = getContext("LayerCake");

  export let toggle;
  export let key;

  $: w = $xScale.bandwidth();

  $: calcH = d => {
    const h = $height - $yGet(d);
    // return 2 + h;
    return h;
  };
</script>

<g class="days">
  {#each $data as d, i (d.dayIndex)}
    <g class="day" transform="translate({$xGet(d)}, 0)">
      <rect
        class="{toggle}
        {key}"
        x="0"
        y="{$yGet(d)}"
        width="{w}"
        height="{calcH(d)}"></rect>
    </g>
  {/each}
</g>
