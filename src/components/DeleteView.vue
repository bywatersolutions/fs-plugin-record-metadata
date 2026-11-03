<template>
  <div>
    <SaveNotice :token="deletedAt">
      <strong>Deleted.</strong> {{ deletedLabel }}
    </SaveNotice>
    <form @submit.prevent="search" class="fsrm-search">
      <select v-model="searchType">
        <option value="biblionumber">TN (biblionumber)</option>
        <option value="barcode">Barcode</option>
      </select>
      <input v-model.trim="searchTerm" placeholder="Find entries to delete" />
      <button type="submit" class="btn btn-primary" :disabled="!searchTerm || loading">
        {{ loading ? "Searching…" : "Find entries" }}
      </button>
    </form>

    <p v-if="error" class="fsrm-error">{{ error }}</p>
    <p v-if="searched && !entries.length && !loading">No entries found.</p>
    <fieldset class="rows">
        <h2>Delete entries</h2>
        <p class="alert alert-warning">
          Deleting an entry also deletes its problems. Deletions are permanent
          and cannot be restored.
        </p>


        <table v-if="entries.length" class="table table-responsive table-success">
          <thead>
            <tr>
              <th>DTN</th>
              <th>TN</th>
              <th>Title</th>
              <th>Access</th>
              <th>Problems</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="e in entries" :key="e.entry_id">
              <td>{{ e.dtn }}</td>
              <td>{{ e.biblionumber }}</td>
              <td>{{ e.title }}</td>
              <td>{{ e.access }}</td>
              <td>{{ problemCount(e) }}</td>
              <td>
                <button class="btn btn-danger" type="button" @click="askDelete(e)">
                  Delete
                </button>
              </td>
            </tr>
          </tbody>
        </table>
            <div
              v-if="pending"
              class="modal show"
              style="display: block"
              tabindex="-1"
              role="dialog"
              aria-labelledby="fsrmDeleteModalLabel"
              aria-modal="true"
            >
              <div class="modal-dialog">
                <div class="modal-content">
                  <div class="modal-header">
                    <h1 class="modal-title" id="fsrmDeleteModalLabel">Delete this entry?</h1>
                    <button
                      type="button"
                      class="btn-close"
                      aria-label="Close"
                      @click="pending = null"
                    ></button>
                  </div>
                  <div class="modal-body">
                    <p>
                      <strong>DTN {{ pending.dtn || "(none)" }}</strong>
                      — TN {{ pending.biblionumber }} — {{ pending.title }}
                    </p>
                    <p class="alert alert-warning">
                      This deletes the entry and its {{ problemCount(pending) }}
                      problem(s). This is permanent  and cannot be undone.
                    </p>
                    <p v-if="deleteError" class="fsrm-error">{{ deleteError }}</p>
                  </div>
                  <div class="modal-footer">
                    <button
                      class="btn btn-primary"
                      type="button"
                      :disabled="deleting"
                      @click="doDelete"
                    >
                      <i class="fa fa-check" aria-hidden="true"></i>
                      {{ deleting ? "Deleting…" : "Delete permanently" }}
                    </button>
                    <button
                      class="btn btn-secondary"
                      type="button"
                      :disabled="deleting"
                      @click="pending = null"
                    >
                      <i class="fa fa-times" aria-hidden="true"></i> Cancel
                    </button>
                  </div>
                </div>
              </div>
            </div>
            <div v-if="pending" class="modal-backdrop fade show"></div>
    </fieldset>
  </div>
</template>

<script>
import { getEntries, deleteEntry } from "../api";

export default {
  name: "DeleteView",
  data() {
    return {
      searchType: "biblionumber",
      searchTerm: "",
      entries: [],
      searched: false,
      loading: false,
      error: null,
      pending: null,
      deleting: false,
      deleteError: null,
      deletedAt: null,
      deletedLabel: "",
    };
  },
  methods: {
    async search() {
      this.loading = true;
      this.error = null;
      this.entries = [];
      this.pending = null;
      try {
        this.entries = await getEntries({ [this.searchType]: this.searchTerm });
      } catch (e) {
        this.error = e.message;
      } finally {
        this.searched = true;
        this.loading = false;
      }
    },

    problemCount(entry) {
      return (entry.problem_numbers || "").split(",").filter(Boolean).length;
    },

    askDelete(entry) {
      this.deleteError = null;
      this.pending = entry;
    },

    async doDelete() {
      this.deleting = true;
      this.deleteError = null;
      const entry = this.pending;
      try {
        await deleteEntry(entry.entry_id);
        const idx = this.entries.findIndex((e) => e.entry_id === entry.entry_id);
        if (idx !== -1) this.entries.splice(idx, 1);
        this.deletedLabel = entry.dtn
          ? `DTN ${entry.dtn} has been deleted.`
          : `Entry ${entry.entry_id} has been deleted.`;
        this.deletedAt = Date.now();
        this.pending = null;
      } catch (e) {
        this.deleteError = e.message;
      } finally {
        this.deleting = false;
      }
    },
  },
};
</script>

<style>
.fsrm-modal-backdrop {
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1050;
}
.fsrm-modal {
  background: #fff;
  padding: 1.5em;
  max-width: 34em;
  border-radius: 4px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
</style>
