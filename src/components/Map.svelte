<style>
  .state {
    position: absolute;
    text-align: center;
    line-height: 1;
    border: 1px solid white;
  }
  p {
    position: absolute;
    margin: 0;
    top: 50%;
    width: 100%;
    transform: translateY(-50%);
    line-height: 1;
    font-weight: bold;
    font-size: 75%;
  }

  ul {
    display: flex;
    justify-content: center;
    list-style-type: none;
    transform: translate(-1.5em, -100%);
  }
  li:first-of-type:before {
    content: "Lower";
    display: block;
    position: absolute;
    top: 0;
    left: 0;
    transform: translateY(-100%);
    font-size: 0.8em;
  }
  li:last-of-type:after {
    content: "Higher";
    display: block;
    position: absolute;
    top: 0;
    right: 0;
    transform: translateY(-100%);
    font-size: 0.8em;
  }
  li {
    position: relative;
    width: 1em;
    height: 1em;
  }
</style>

<script>
  // Import the getContext function from svelte
  import { getContext } from "svelte";
  import { format } from "d3-format";
  import { scaleQuantize } from "d3-scale";

  export let toggle = "capita_test";

  export let seriesColors = [
    "#ebdae0",
    "#f1c9d9",
    "#f5b6d2",
    "#f9a3ca",
    "#fc8fc3",
    "#fd7abc",
    "#ff61b5",
    "#ff43ad",
    "#ff00a6"
  ];

  const { data, x, y, extents } = getContext("LayerCake");

  function percent(v) {
    return format("%")(v);
  }

  // Access the context using the 'LayerCake' keyword
  // Grab some helpful functions
  $: max = Math.max(...$data.map(d => d[toggle]));

  $: colorScale = scaleQuantize()
    .domain([0, max])
    .range(seriesColors);

  $: w = $extents.x[1] + 1;
  $: h = $extents.y[1] + 1;
  $: stateW = percent(1 / w);
  $: stateH = percent(1 / h);
</script>

<ul>
  {#each seriesColors as c}
    <li style="background-color: {c};"></li>
  {/each}
</ul>
{#each $data as d (d.code)}
  <div
    class="state"
    data-capita="{d.capita}"
    style="left: {percent($x(d) / w)}; top: {percent($y(d) / h)}; width: {stateW};
    height: {stateH}; background-color: {colorScale(d[toggle])};">
    <p>{d.code}</p>
  </div>
{/each}
