import * as React from "react";

import Modal from "react-responsive-modal";

import Logger from "../Logger";

// interface BookBuyerProps { className?: string }

class BookBuyer extends React.Component<any, any> {
	constructor(props: any) {
		super(props);
		this.state = {
			bookDropdownSelection: "1",
			formValue: "",
			modalOpen: false,
			recomendedBooks: [],
			rules: [],
			selectedBook: null,
		};
	}

	public render() {
		const { modalOpen } = this.state;
		return (
			<div>
				<h2>Content based fitering</h2>
				<h3>Recomending similar books based on their properties</h3>
				<button onClick={ this.openModal }>Browse books</button>
				<Modal
					open={ modalOpen }
					onClose={ this.closeModal }
				>
					<img src={require("../../books/all_books.png")}></img>
				</Modal>
				<form onSubmit={ this.formSubmit }>
					<label>
					Buy book:
					</label>
					{" "}
					<select onChange={ this.selectChange }>
						{ this.populateBookOptions() }
					</select>
					{" "}
					<input type="submit" value="Submit" />
				</form>
				<div>Recomended books: { this.getBooks(this.state.recomendedBooks) } </div>
				<div>Rules: { this.state.rules.toString() } </div>
			</div>
		);
	}

	private getBooks = (recomendedBooks: number[]) => (
		recomendedBooks.map((bookNumber) => <img src={require(`../../books/mini/minbook${bookNumber}.png`)}></img>)
	)

	private openModal = () => {
		Logger.info("Showing Modal");
		this.setState({ modalOpen: true });
	}
	private closeModal = () => {
		Logger.info("Hiding Modal");
		this.setState({ modalOpen: false });
	}

	private populateBookOptions = () => {
		const array: JSX.Element[] = [];
		for (let i = 1; i <= 20; i++) {
			array.push(<option key={i} value={i}>Book {i}</option>);
		}
		return array;
	}

	private selectChange = (event: React.ChangeEvent) => {
		Logger.info("Updating change");
		this.setState({ bookDropdownSelection: event.target.nodeValue });
	}

	private formSubmit = (event: React.FormEvent) => {
		event.preventDefault();
		const selectedBook: number = Number(this.state.bookDropdownSelection);
		Logger.info("selected book", selectedBook);
		if (! isNaN(selectedBook)) {
			Logger.info("Is a number");
			this.setState({ selectedBook }, () => {
				this.sendBookPurchase(this.state.selectedBook);
				this.sendBookApriori(this.state.selectedBook);
			});
		} else {
			Logger.error("Not a number");
		}
	}

	private sendBookPurchase = (bookId: number) => {
		Logger.info("book id", bookId);
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
