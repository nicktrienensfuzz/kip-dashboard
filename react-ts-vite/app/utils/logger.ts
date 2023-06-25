type LoggerParams = any[];

class Logger {
  warn(...data: LoggerParams) {
    data.unshift("[WARN]: ");
    // eslint-disable-next-line no-console
    console.warn.apply(console, data);
  }

  error(...data: LoggerParams) {
    data.unshift("[ERROR]: ");
    // eslint-disable-next-line no-console
    console.error.apply(console, data);
  }

  halt(s: string) {
    throw new Error("[HALT]: " + s);
  }

  log(...data: LoggerParams) {
    data.unshift("[LOG]: ");
    // eslint-disable-next-line no-console
    console.warn.apply(console, data);
  }

  debug(...data: LoggerParams) {
    if (process.env.DEBUG) {
      this.log(...data);
    }
  }
}

export default Logger;
