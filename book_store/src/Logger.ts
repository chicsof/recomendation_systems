import debug from "debug";

const base = "book_store";

class Logger {
	public generateMessage(level: any, message: any, source: any) {
		const namespace = `${base}:${level}`;
		const createDebug = debug(namespace);

		source ? createDebug(source, message) : createDebug(message);
	}

	public trace = (message: any, source?: any) => this.generateMessage("trace", message, source);

	public info = (message: any, source?: any) => this.generateMessage("info", message, source);

	public warn = (message: any, source?: any) => this.generateMessage("warn", message, source);

	public error = (message: any, source?: any) => this.generateMessage("error", message, source);
}

export default new Logger();
