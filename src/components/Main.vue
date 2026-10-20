<template>
  <div class="fs-record-metadata">
    <NavBar :current="view" @navigate="view = $event" />
    <SearchView
      v-if="view === 'search'"
      :search-type="searchType"
      :search-term="searchTerm"
      @search="onSearch"
      @select="openEntry"
    />
    <CreateView
      v-if="view === 'new'"
      :search-type="searchType"
      :search-term="searchTerm"
      @search="onSearch"
      @created="openEntry"
    />
    <BulkCreateView v-if="view === 'bulknew'" @created="openEntry" />
    <ScanningViewOne
      v-if="view === 'create'"
      :entry="entry"
      :search-type="searchType"
      :search-term="searchTerm"
      @search="onSearch"
      @saved="onSaved"
      @step="onStep"
      @cancel="closeEntry"
    />
    <ScanningViewTwo
      v-if="view === 'create2'"
      :entry="entry"
      :search-type="searchType"
      :search-term="searchTerm"
      @search="onSearch"
      @saved="onSaved"
      @step="onStep"
      @cancel="closeEntry"
    />
    <ProblemsView v-if="view === 'problems'" />
    <AdminView v-if="view === 'admin'" />
  </div>
</template>

<script>
import SearchView from "./SearchView.vue";
import CreateView from "./CreateView.vue";
import BulkCreateView from "./BulkCreateView.vue";
import ScanningViewOne from "./ScanningViewOne.vue";
import ScanningViewTwo from "./ScanningViewTwo.vue";
import ProblemsView from "./ProblemsView.vue";
import AdminView from "./AdminView.vue";

export default {
  name: "Main",
  components: { SearchView, CreateView, BulkCreateView, ScanningViewOne, ScanningViewTwo, ProblemsView, AdminView },
  data() {
    return { view: "search", entry: null, searchType: "biblionumber", searchTerm: "", };
  },
  methods: {
    onSearch({ type, term }) {
    console.log("Main.onSearch", type, term);
      this.searchType = type;
      this.searchTerm = term;
    },
    openEntry(entry) {
      this.entry = entry;
      this.view = "create";
    },
    onSaved(updated) {
      this.entry = updated;
    },
    onStep(n) {
      this.view = n === 2 ? "create2" : "create";
    },
    closeEntry() {
      this.entry = null;
      this.view = "search";
    },
  },
};
</script>

<style>
.fs-record-metadata {
  padding: 1rem;
}
</style>
