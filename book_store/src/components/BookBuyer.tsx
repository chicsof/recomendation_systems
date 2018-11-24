import * as React from "react";

import Modal from "react-responsive-modal";
import Select from "react-select";

import Logger from "../Logger";

const baseUrl = (process.env.NODE_ENV === "production") ? "https://datasupport.site/r" : "http://localhost:8000";

// interface BookBuyerProps { className?: string }

class BookBuyer extends React.Component<any, any> {
	constructor(props: any) {
		super(props);
		const options = this.generateBookOptions();
		this.state = {
			bookDropdownSelection: "1",
			formValue: "",
			modalOpen: {
				allBooks: false,
				rules: false,
				transactionHistory: false,
			},
			options,
			recomendedBooks: [],
			rules: [],
			selectedBook: options[0],
		};
	}

	public render() {
		const { modalOpen, options, recomendedBooks, rules } = this.state;
		const browseStyle: React.CSSProperties = {
			backgroundColor: "#5FBC4F",
			border: 0,
			borderRadius: "4px",
			color: "#FFF",
			fontSize: "1.2em",
			margin: "1.1em",
			padding: "1em",
		};

		const buyStyle: React.CSSProperties = {
			backgroundColor: "#3DA047",
			border: 0,
			borderRadius: "4px",
			color: "#FFF",
			fontSize: "1.2em",
			margin: "0.3em",
			padding: ".4em",
		};

		return (
			<div>
				<button onClick={ () => this.openModals("allBooks") } style={ browseStyle }>
					Browse books
				</button>
				<Modal
					open={ modalOpen.allBooks }
					onClose={ () => this.closeModals("allBooks") }
				>
					<img src={require("../../books/all_books.png")}></img>
				</Modal>
				<div>
					<label style={ { fontSize: "2em" } }>
						Buy book:
					</label>
					<div style={{ maxWidth: 300, display: "inline-block", width: "100%", margin: "10px" }}>
						<Select
							onChange={ this.selectChange }
							options={ options }
							defaultValue={ options[0] }
							theme={(theme) => ({
								...theme,
								borderRadius: 0,
								colors: {
									...theme.colors,
									primary: "#5FBC4F",
									primary25: "rgba(95, 188, 79, 0.4)",
								}})
							}
						/>
					</div>
				<button style={ buyStyle } onClick={ this.sendPurchase }>Buy</button>
				</div>
				<h2>Content based fitering</h2>
				<h3>Recomending similar books based on their properties</h3>
				<p>Recomended books:</p>
				<div style={ { display: "flex", textAlign: "center", flexWrap: "wrap", alignItems: "center" } }>
					{ this.getBooksRecomendations(recomendedBooks) }
				</div>
				<h2>Mining item association rules</h2>
				<h3>Recomending items that are often bought together</h3>
				<button onClick={ () => this.openModals("rules") } style={ buyStyle }>
					View the mined associations
				</button>
				<Modal
					open={ modalOpen.rules }
					onClose={ () => this.closeModals("rules") }
					classNames={{ modal: "minedAssociationsModal" }}
				>
					<img src={require("../../books/rules.png")}/>
				</Modal>
				<button onClick={ () => this.openModals("transactionHistory") } style={ buyStyle }>
					View transaction history
				</button>
				<Modal
					open={ modalOpen.transactionHistory }
					onClose={ () => this.closeModals("transactionHistory") }
				>
					<img src={require("../../books/transactions.png")}/>
				</Modal>
				<p>Rules based recomendations:</p>
				<div>
					{ this.getBooksRules(rules) }
				</div>
				<p/>
			</div>
		);
	}

	private selectChange = (selected: any) => {
		this.setState({ selectedBook: selected });
	}

	private getBooksRecomendations = (recomendedBooks: number[]) => {
		const bookList = this.getBooks(recomendedBooks);
		return (bookList.length > 0)
			? bookList
			: <div style={ { color: "#AEAEAE" } }>Please buy a book to recive a recomendation</div>;
	}

	private getBooksRules = (recomendedBooks: number[]) => {
		if (recomendedBooks.length === 1 && recomendedBooks[0] === 0) {
			return <div style={ { color: "#AEAEAE" } }>There is no rule for this book</div>;
		} else {
			const bookList = this.getBooks(recomendedBooks);
			Logger.info("a", bookList);
			return (bookList.length > 0)
				? bookList
				: <div style={ { color: "#AEAEAE" } }>Please buy a book to recive a recomendation</div>;
		}
	}

	private getBooks = (recomendedBooks: number[]) => (
		recomendedBooks.map((bookNumber, bookIndex) =>
			<img
				key={bookIndex}
				style={ { display: "inline-table", width: 170, padding: 10 } }
				height={150}
				src={require(`../../books/mini/minbook${bookNumber}.png`)}
			/>,
		)
	)

	private openModals = (key: string) => {
		Logger.info("Showing Modal");
		this.setState({ modalOpen: {
			...this.state.modalOpen,
			[key]: true,
		}});
	}
	private closeModals = (key: string) => {
		Logger.info("Hiding Modal");
		this.setState({ modalOpen: {
			...this.state.modalOpen,
			[key]: false,
		}});
	}

	private generateBookOptions = () => {
		const array = [];
		for (let i = 1; i <= 20; i++) {
			array.push({ value: i, label: `Book ${i}` });
		}
		return array;
	}

	private sendPurchase = () => {
		const { selectedBook } = this.state;
		this.sendBookPurchase(selectedBook.value);
		this.sendBookApriori(selectedBook.value);

	}

	private sendBookPurchase = (bookId: number) => {
		Logger.info("sendBookPurchase bookId", bookId);
		fetch(`${baseUrl}/closestThree`, {
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
		Logger.info("sendBookApriori bookId", bookId);
		fetch(`${baseUrl}/rules`, {
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
