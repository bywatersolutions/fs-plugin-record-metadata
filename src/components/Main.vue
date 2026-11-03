<template>
  <div class="fs-record-metadata">
    <NavBar :current="view" @navigate="onNavigate" />
    <SaveNotice :token="savedNotice && savedNotice.at">
      <strong>Saved.</strong> {{ savedNoticeText }}
    </SaveNotice>
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
    />
    <ScanningViewTwo
      v-if="view === 'create2'"
      :entry="entry"
      :search-type="searchType"
      :search-term="searchTerm"
      @search="onSearch"
      @saved="onSaved"
      @step="onStep"
    />
    <DeleteView v-if="view === 'delete'" />
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
import DeleteView from "./DeleteView.vue";
import { isDirty } from "../dirty";

export default {
  name: "Main",
  components: { SearchView, CreateView, BulkCreateView, ScanningViewOne, ScanningViewTwo, DeleteView, ProblemsView, AdminView },
  data() {
    return { view: "search", entry: null, searchType: "biblionumber", searchTerm: "", savedNotice: null };
  },
  computed: {
    savedNoticeText() {
      if (!this.savedNotice) return "";
      return this.savedNotice.dtn
        ? `DTN ${this.savedNotice.dtn} has been updated.`
        : `Entry ${this.savedNotice.entry_id} has been updated.`;
    },
  },
  methods: {
    onSearch({ type, term }) {
      this.searchType = type;
      this.searchTerm = term;
      this.savedNotice = null;
    },
    openEntry(entry) {
      this.entry = entry;
      this.view = "create";
    },
    onSaved(updated) {
      this.entry = updated;
      this.savedNotice = { at: Date.now(), dtn: updated.dtn, entry_id: updated.entry_id };
    },
    onStep(n) {
      this.view = n === 2 ? "create2" : "create";
    },
    onNavigate(view) {
      if (isDirty() && !window.confirm("You have unsaved changes. Leave this page and lose them?")) {
        return;
      }
      this.view = view;
      this.savedNotice = null;
    },
  },
};
</script>

<style>
.fs-record-metadata {
  padding: 1rem;
}
</style>
