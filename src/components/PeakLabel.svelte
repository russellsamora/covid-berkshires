<style>
  p {
    position: absolute;
    transform: translate(0, -100%);
    font-size: 11px;
    margin: 0;
    margin-top: -0.5rem;
    background: #fff;
    padding: 0;
    line-height: 1.4;
    color: var(--black);
    font-weight: bold;
    text-align: center;
    border-bottom: 1px dashed var(--gray);
  }
  p:after {
    content: "";
    display: block;
    position: absolute;
    right: 0px;
    top: 100%;
    height: 0.5rem;
    width: 0;
    border-right: 1px dashed var(--gray);
  }
  span {
    font-weight: normal;
  }
  p.Berkshire {
    color: var(--highlightText);
    border-bottom: 1px dashed var(--highlight);
  }
  p.Berkshire:after {
    border-right: 1px dashed var(--highlight);
  }
</style>

<script>
  import { getContext } from "svelte";
  import { max } from "d3-array";

  const { data, x, width, xGet, yGet, xScale } = getContext("LayerCake");
  export let key;
  export let toggle;
  export let formatTickY = d => d;
  export let i = 0;

  const suffix = {
    casesCapita: "cases per 1,000",
    cases: "total cases",
    deathsCapita: "deaths per 1,000",
    deaths: "total deaths",
    casesNew: "reported cases",
    deathsNew: "reported deaths"
  };

  $: val = max($data, d => d[toggle]);
  $: d = $data.find(v => v[toggle] === val);
  $: text = formatTickY(val);
  $: top = $yGet(d);
  $: right = $width - $xGet(d) - $xScale.bandwidth() / 2 - 2;
</script>

<p class="{key}" style="top:{top}px;right:{right}px;">
  {text}
  <span>{i === 0 ? suffix[toggle] : ''}</span>
</p>
