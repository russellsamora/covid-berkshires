<style>
  p {
    position: absolute;
    transform: translate(0, -125%);
    font-size: 12px;
    margin: 0;
    background: #fff;
    padding: 0;
    line-height: 1;
    color: var(--black);
    font-weight: bold;
    text-align: center;
  }
  p.Berkshire {
    color: var(--highlightText);
  }
</style>

<script>
  import { getContext } from "svelte";

  const { data, x, width, xGet, yGet } = getContext("LayerCake");

  $: max = v => v[v.length - 1];
  $: right = values => $width - $xGet(max(values));
  $: top = values => $yGet(max(values));
</script>

{#each $data as d (d.key)}
  <p class="{d.key}" style="top:{top(d.value)}px;right:{right(d.value)}px;">
    {d.key.includes('Mass') ? d.key : `${d.key} County`}
  </p>
{/each}
