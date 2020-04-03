<style>
  table {
    max-width: 720px;
    margin: 3rem auto;
    width: 100%;
  }
  tr:nth-child(even) {
    background-color: #eee;
  }
  td,
  th {
    padding: 0.5em;
    border: none;
    font-size: 0.85em;
  }
  tr td:nth-child(1),
  tr th:nth-child(1) {
    text-align: left;
  }
  tr td:nth-child(n + 1),
  tr th:nth-child(n + 1) {
    text-align: right;
  }
</style>

<script>
  import { format } from "d3-format";
  export let data;
</script>

<table>
  <thead>
    <tr>
      <th>State</th>
      <th>Positive per 1,000</th>
      <th>Positive tests</th>
      <th>Tests per 1,000</th>
      <th>Total tests</th>
      <th>% positive</th>
    </tr>
  </thead>
  <tbody>
    {#each data as d (d.code)}
      <tr>
        <td>{d.state}</td>
        <td>{format('.2f')(d.capita_pos * 1000)}</td>
        <td>{format(',')(d.positive)}</td>
        <td>{format('.2f')(d.capita_test * 1000)}</td>
        <td>{format(',')(d.total)}</td>
        <td>{format('.0%')(d.percent)}</td>
      </tr>
    {/each}
  </tbody>
</table>
