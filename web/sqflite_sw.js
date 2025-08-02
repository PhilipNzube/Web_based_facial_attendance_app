self.importScripts(
  "https://cdn.jsdelivr.net/npm/sql.js@1.6.2/dist/sql-wasm.js"
);

let db;

self.onmessage = async function (e) {
  const { id, method, params } = e.data;

  try {
    switch (method) {
      case "init":
        db = new SQL.Database();
        self.postMessage({ id, result: "initialized" });
        break;

      case "exec":
        const result = db.exec(params.sql);
        self.postMessage({ id, result });
        break;

      default:
        throw new Error(`Unknown method: ${method}`);
    }
  } catch (e) {
    self.postMessage({ id, error: e.message });
  }
};
