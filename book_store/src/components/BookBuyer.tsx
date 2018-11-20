import * as React from "react";

import Logger from "../Logger";

// interface BookBuyerProps { className?: string }

class BookBuyer extends React.Component<any, any> {
	constructor(props: any) {
		super(props);
		this.state = {
			formValue: "",
			recomendedBooks: [],
			rules: [],
			selectedBook: null,
		};
	}

	public render() {
		return (
			<div>
				<form onSubmit={ this.formSubmit }>
					<label>
					Book Number:
					<input type="text" value={ this.state.formValue } onChange={ this.formChange } />
					</label>
					<input type="submit" value="Submit" />
				</form>
				<div>Recomended books: { this.state.recomendedBooks.toString() } </div>
				<div>Rules: { this.state.rules.toString() } </div>
			</div>
		);
	}

	private formSubmit = (event: React.FormEvent) => {
		event.preventDefault();
		const selectedBook: number = Number(this.state.formValue);
		if (! isNaN(selectedBook)) {
			Logger.info("Is a number");
			this.setState({ selectedBook: this.state.formValue }, () => {
				this.sendBookPurchase(this.state.selectedBook);
				this.sendBookApriori(this.state.selectedBook);
			});
		} else {
			Logger.error("Not a number");
		}
	}

	private formChange = (event: any) => {
		this.setState({ formValue: event.target.value });
	}

	private sendBookPurchase = (bookId: number) => {
		Logger.info(bookId);
		fetch("http://localhost:8000/closestThree", {
			body: JSON.stringify({ bookNumber: bookId }),
			method: "POST",
		}).then(
			(value) => {
				value.json().then(
					(result) => {
						Logger.info(result);
						Logger.info(typeof(result));
						this.setState({ recomendedBooks: result });
					},
					(error) => Logger.info(error),
				);
			},
			(error) => Logger.info(error),
		);
	}

	private sendBookApriori = (bookId: number) => {
		Logger.info(bookId);
		fetch("http://localhost:8000/rules", {
			body: JSON.stringify({ bookNumber: bookId }),
			method: "POST",
		}).then(
			(value) => {
				value.json().then(
					(result) => {
						Logger.info(result);
						Logger.info(typeof(result));
						this.setState({ rules: result });
					},
					(error) => Logger.info(error),
				);
			},
			(error) => Logger.info(error),
		);
	}
}

export default BookBuyer;
