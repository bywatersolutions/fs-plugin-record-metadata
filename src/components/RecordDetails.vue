<template>
  <fieldset class="rows results" v-if="record">
    <div>
      <h3>Bibliographic information</h3>
      <ol>
        <li><span class="label">Title:</span> {{ record.title }}</li>
        <li><span class="label">Author:</span> {{ record.author }}</li>
        <li>
          <span class="label">Publisher Date:</span>
          {{ record.publication_date }}
        </li>
        <li>
          <span class="label">Physical description:</span>
          {{ record.physical_description }}
        </li>
        <li>
          <span class="label">Language:</span>
          {{ record.lang }}
        </li>
      </ol>
      <hr />
      <h3>Online links</h3>
      <table
        class="table table-success table-responsive"
        v-if="record.online_links && record.online_links.length"
      >
        <thead>
          <tr>
            <th>Online link (856u)</th>
            <th>Limb ID (856f)</th>
            <th>DJS (856w)</th>
            <th>(856y)</th>
            <th>(856x)</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(link, idx) in record.online_links" :key="idx">
            <td>
              <a v-if="link.url" :href="link.url" target="_blank" rel="noopener">{{
                link.url
              }}</a>
            </td>
            <td>
                {{ link.f856 }}
            </td>
            <td>
                {{ link.w856 }}
            </td>
            <td>
                {{ link.y856 }}
            </td>
            <td>
                {{ link.x856 }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div>
      <h3>Item information</h3>
      <table
        class="fsrm-items table table-success table-responsive"
        v-if="record.items && record.items.length"
      >
        <thead>
          <tr>
            <th>Item type</th>
            <th>Home library</th>
            <th>Call number</th>
            <th>Barcode</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="i in record.items" :key="i.itemnumber">
            <td>{{ i.itemtype }}</td>
            <td>{{ i.branchname || i.homebranch }}</td>
            <td>{{ i.callnumber }}</td>
            <td>{{ i.barcode }}</td>
          </tr>
        </tbody>
      </table>
      <p v-else><em>No configured items attached to this record. Some items maye be hidden via the configuration page.</em></p>
      <hr />
      <h3>Rights</h3>
      <ol class="fsrm-rights">
        <li>
          <span class="label">Privacy (998$f):</span>
          <div v-for="(v, i) in record.privacy_998f" :key="i">{{ v }}</div>
          <span v-if="!(record.privacy_998f && record.privacy_998f.length)">—</span>
        </li>
        <li>
          <span class="label">Contract (542$r):</span>
          <div v-for="(v, i) in record.contract_542r" :key="i">{{ v }}</div>
          <span v-if="!(record.contract_542r && record.contract_542r.length)">—</span>
        </li>
        <li>
          <span class="label">Ex 108 (506$a):</span>
          <div v-for="(v, i) in record.ex_108" :key="i">{{ v }}</div>
          <span v-if="!(record.ex_108 && record.ex_108.length)">—</span>
        </li>
        <li>
          <span class="label">Copyright (542$l):</span>
          <div v-for="(v, i) in record.copyright_542l" :key="i">{{ v }}</div>
          <span v-if="!(record.copyright_542l && record.copyright_542l.length)">—</span>
        </li>
      </ol>
    </div>
  </fieldset>
</template>

<script>
export default {
  name: "RecordDetails",
  props: {
    record: { type: Object, default: null },
  },
};
</script>
<style>
.fs-record-metadata .fsrm-rights {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2px;
}
.fs-record-metadata .fsrm-rights > li {
  padding: 0.4em 0.6em;
}
.fs-record-metadata .fsrm-rights > li {
  background: #eee;
}
</style>
