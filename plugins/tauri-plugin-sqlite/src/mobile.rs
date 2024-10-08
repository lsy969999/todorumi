use serde::de::DeserializeOwned;
use tauri::{
  plugin::{PluginApi, PluginHandle},
  AppHandle, Runtime,
};
use crate::args::*;
use crate::models::*;

#[cfg(target_os = "android")]
const PLUGIN_IDENTIFIER: &str = "lsy969999.plugin.todolumi.sqlite";

#[cfg(target_os = "ios")]
tauri::ios_plugin_binding!(init_plugin_sqlite);

// initializes the Kotlin or Swift plugin classes
pub fn init<R: Runtime, C: DeserializeOwned>(
  _app: &AppHandle<R>,
  api: PluginApi<R, C>,
) -> crate::Result<Sqlite<R>> {
  #[cfg(target_os = "android")]
  let handle = api.register_android_plugin(PLUGIN_IDENTIFIER, "SqlitePlugin")?;
  #[cfg(target_os = "ios")]
  let handle = api.register_ios_plugin(init_plugin_sqlite)?;
  Ok(Sqlite(handle))
}

/// Access to the sqlite APIs.
pub struct Sqlite<R: Runtime>(PluginHandle<R>);

impl<R: Runtime> Sqlite<R> {
  pub fn ping(&self, payload: PingRequest) -> crate::Result<PingResponse> {
    self
      .0
      .run_mobile_plugin("ping", payload)
      .map_err(Into::into)
  }

  pub fn get_db_user_version(&self) -> crate::Result<GetDbUserVersionRes> {
    self
      .0
      .run_mobile_plugin("getDbUserVersion", ())
      .map_err(Into::into)
  }

  pub fn get_all_todo(&self) -> crate::Result<GetAllTodoRes> {
    self
      .0
      .run_mobile_plugin("getAllTodo", ())
      .map_err(Into::into)
  }

  pub fn insert_todo(&self, payload: InsertTodoReq) -> crate::Result<InsertTodoRes> {
    self
      .0
      .run_mobile_plugin("insertTodo", payload)
      .map_err(Into::into)
  }
}
