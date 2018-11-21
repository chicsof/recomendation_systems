import * as React from "react";

import Rating from "./RatingWrapper";

import Logger from "../Logger";

export default class BookBuyer extends React.Component<any, any> {
	constructor(props: any) {
		super(props);
		const ratings: any = {};
		for (let i = 1; i <= 20; i++) {
			ratings[`book${i}`] = undefined;
		}
		this.state = {
			ratings,
			recomendations: {},
		};
	}

	public render() {
		return (
			<div>
				{this.generateBookRatings()}
				<button onClick={ () => this.sendRating() }>Click</button>
				<br/>
				Result:
				{ JSON.stringify(this.state.recomendation) }
			</div>
		);
	}

	private generateBookRatings = () => {
		const { ratings } = this.state;

		return Object.keys(ratings).map((key: string) => (
			<Rating key={ key } book={ key } rating={ ratings[key] } onChange={ this.newRatingChange } />
		));
	}

	private newRatingChange = (key: string, rating: number) => {
		const { ratings } = this.state;
		this.setState({
			ratings: {
				...ratings,
				[key]: rating,
			},
		});
	}

	private sendRating = () => {
		const { ratings } = this.state;
		const objectMap = (object: any, mapFn: any) => (
			Object.keys(object).reduce(
				(result: any, key: string) => {
					result[key] = mapFn(object[key]);
					return result;
				},
				{},
			)
		);

		const data = objectMap(ratings, (value: string) => (
			(value === "null") ? null : parseInt(value, 10)
		));

		Logger.info("new");
		Logger.info(data);

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
