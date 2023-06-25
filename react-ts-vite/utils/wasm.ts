type TOnLoadCallback = (
  mod: WebAssembly.Module,
  inst: WebAssembly.Instance
) => void;

export const loadWasm = async (path: string, onLoad: TOnLoadCallback) => {
  const fetchResult = fetch(path);
  const { module, instance } = await WebAssembly.instantiateStreaming(
    fetchResult
  );
  onLoad(module, instance);
};
