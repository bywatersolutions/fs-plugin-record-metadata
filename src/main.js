import { createApp } from "vue";

import NavBar from "./components/NavBar.vue";
import App from "./components/Main.vue";
import DateField from "./components/DateField.vue";
import StaffPicker from "./components/StaffPicker.vue";
import AvSelect from "./components/AvSelect.vue";
import AccessLevel from "./components/AccessLevel.vue";
import RecordDetails from "./components/RecordDetails.vue";
import SaveNotice from "./components/SaveNotice.vue";

const app = createApp(App);

app.component("NavBar", NavBar);
app.component("DateField", DateField);
app.component("StaffPicker", StaffPicker);
app.component("AvSelect", AvSelect);
app.component("AccessLevel", AccessLevel);
app.component("RecordDetails", RecordDetails);
app.component("SaveNotice", SaveNotice);

app.config.globalProperties.$canWrite = () => !!(window.fsrmAccess || {}).can_write;
app.config.globalProperties.$canView = (id) => ((window.fsrmAccess || {}).views || []).includes(id);

app.mount("#__app");
