<style>
  p {
    position: absolute;
    transform: translate(0, -125%);
    font-size: 12px;
    margin: 0;
    background: #fff;
    padding: 2px 0;
    line-height: 1;
    color: var(--black);
    font-weight: bold;
    text-align: center;
  }
  p.casesCapita {
    transform: translate(0, -125%);
  }
  p.Berkshire {
    transform: translate(0, 200%);
    color: var(--highlightText);
  }
  p.casesCapita.Berkshire {
    transform: translate(0, 200%);
  }
  .circle {
    position: absolute;
    width: 8px;
    height: 8px;
    background-color: var(--gray);
    border-radius: 50%;
    transform: translate(4px, -50%);
  }
  .circle.Berkshire {
    background-color: var(--highlightText);
  }
</style>

<script>
  import { getContext } from "svelte";

  export let toggle;

  const { data, x, width, xGet, yGet } = getContext("LayerCake");

  $: max = v => v[v.length - 1];
  $: right = values => $width - $xGet(max(values));
  $: top = values => $yGet(max(values));
</script>

{#each $data as d (d.key)}
  <p
    class="{d.key}
    {toggle}"
    style="top:{top(d.value)}px;right:{right(d.value)}px;">
    {d.key.includes('Mass') ? d.key : `${d.key} County`}
  </p>
  <div
    class="circle {d.key}
    {toggle}"
    style="top:{top(d.value)}px;right:{right(d.value)}px;"></div>
{/each}
