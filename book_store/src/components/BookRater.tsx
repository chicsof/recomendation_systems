import * as React from "react";

import Logger from "../Logger";
import Rating from "./Rating";

// interface BookBuyerProps { className?: string }

class BookBuyer extends React.Component<any, any> {
	constructor(props: any) {
		super(props);
		this.state = {
			ratings: {
				book1: "null",
				book2: "null",
				book3: "null",
				book4: "null",
				book5: "null",
				book6: "null",
				book7: "null",
				book8: "null",
				book9: "null",
				book10: "null",
				book11: "null",
				book12: "null",
				book13: "null",
				book14: "null",
				book15: "null",
				book16: "null",
				book17: "null",
				book18: "null",
				book19: "null",
				book20: "null",
			},
			recomendations: {},
		};
	}

	public render() {
		return (
			<div>
				<Rating name="book1" value={this.state.ratings.book1} onChange={ this.ratingChange } />
				<Rating name="book2" value={this.state.ratings.book2} onChange={ this.ratingChange } />
				<Rating name="book3" value={this.state.ratings.book3} onChange={ this.ratingChange } />
				<Rating name="book4" value={this.state.ratings.book4} onChange={ this.ratingChange } />
				<Rating name="book5" value={this.state.ratings.book5} onChange={ this.ratingChange } />
				<Rating name="book6" value={this.state.ratings.book6} onChange={ this.ratingChange } />
				<Rating name="book7" value={this.state.ratings.book7} onChange={ this.ratingChange } />
				<Rating name="book8" value={this.state.ratings.book8} onChange={ this.ratingChange } />
				<Rating name="book9" value={this.state.ratings.book9} onChange={ this.ratingChange } />
				<Rating name="book10" value={this.state.ratings.book10} onChange={ this.ratingChange } />
				<Rating name="book11" value={this.state.ratings.book11} onChange={ this.ratingChange } />
				<Rating name="book12" value={this.state.ratings.book12} onChange={ this.ratingChange } />
				<Rating name="book13" value={this.state.ratings.book13} onChange={ this.ratingChange } />
				<Rating name="book14" value={this.state.ratings.book14} onChange={ this.ratingChange } />
				<Rating name="book15" value={this.state.ratings.book15} onChange={ this.ratingChange } />
				<Rating name="book16" value={this.state.ratings.book16} onChange={ this.ratingChange } />
				<Rating name="book17" value={this.state.ratings.book17} onChange={ this.ratingChange } />
				<Rating name="book18" value={this.state.ratings.book18} onChange={ this.ratingChange } />
				<Rating name="book19" value={this.state.ratings.book19} onChange={ this.ratingChange } />
				<Rating name="book20" value={this.state.ratings.book20} onChange={ this.ratingChange } />
				<button onClick={ () => this.sendRating() }>Click</button>
				<br/>
				Meme:
				{ JSON.stringify(this.state.ratings) }
				<br/>
				Result:
				{ JSON.stringify(this.state.recomendation) }
			</div>
		);
	}

	private ratingChange = (event: any) => {
		const butts = Object.assign({}, this.state.ratings);
		butts[event.target.name] = event.target.value;
		this.setState({ ratings: butts });
	}

	private sendRating = () => {
		Logger.info("original");
		Logger.info(this.state.ratings);
		const objectMap = (object: any, mapFn: any) => (
			Object.keys(object).reduce(
				(result: any, key: string) => {
					result[key] = mapFn(object[key]);
					return result;
				},
				{},
			)
		);

		const data = objectMap(this.state.ratings, (value: string) => (
			(value === "null") ? null : parseInt(value, 10)
		));
		// const data = JSON.parse(JSON.stringify(this.state.ratings, replacer));
		Logger.info("new");
		Logger.info(data);
		// const data = {
		// 	book1: 5,
		// 	book2: null,
		// 	book3: 5,
		// 	book4: null,
		// 	book5: null,
		// 	book6: null,
		// 	book7: null,
		// 	book8: null,
		// 	book9: null,
		// 	book10: null,
		// 	book11: null,
		// 	book12: null,
		// 	book13: null,
		// 	book14: null,
		// 	book15: null,
		// 	book16: 2,
		// 	book17: 1,
		// 	book18: 1,
		// 	book19: null,
		// 	book20: null,
		// };

		fetch("http://localhost:8000/rating", {
			body: JSON.stringify(data),
			method: "POST",
		}).then(
			(value) => {
				value.json().then(
					(result) => {
						Logger.info(result);
						Logger.info(typeof(result));
						this.setState({ recomendation: result });
					},
					(error) => Logger.info(error),
				);
			},
			(error) => Logger.info(error),
		);
	}
}

export default BookBuyer;
