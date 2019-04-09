import * as React from "react";

import Modal from "react-responsive-modal";
import { toast } from "react-toastify";

import Logger from "../Logger";
import Rating from "./RatingWrapper";

const baseUrl = (process.env.NODE_ENV === "production") ? "https://r.book-rating.shop" : "http://localhost:8000";

export default class BookBuyer extends React.Component<any, any> {
	constructor(props: any) {
		super(props);
		const ratings = this.generateInitialRatings();
		this.state = {
			modalOpen: false,
			ratings,
			recomendations: {},
		};
	}

	public render() {
		const { recomendations, modalOpen } = this.state;
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
				<h2>Collaborative filtering</h2>
				<h3>Recomending books that were liked by similar users</h3>
				<p>Please rate some books; we will recomend books we think you will like.</p>
				<div>
					<button style={ buyStyle } onClick={ this.openModal }>
						View rating matrix
					</button>
					<Modal
						open={ modalOpen }
						onClose={ this.closeModal }
						classNames={{ modal: "ratingMatrixModal" }}
					>
						<img src={require("../../books/ratings_matrix.png")}/>
					</Modal>
				</div>
				<div>
					<button
						style={ { ...buyStyle, fontSize: "1em", padding: ".2em" } }
						onClick={ this.resetStateRatings }>Reset all</button>
				</div>
				<div style={{ display: "flex", textAlign: "center", flexWrap: "wrap" }}>
					{this.generateBookRatings()}
				</div>
				<button style={ buyStyle } onClick={ () => this.sendRating() }>Submit Ratings</button>
				<p>Recomendations and predicted ratings:</p>
				<div style={{ display: "flex", textAlign: "center", flexWrap: "wrap" }}>
					{ this.generateRatingsResults(recomendations) }
				</div>
			</div>
		);
	}

	private openModal = () => {
		Logger.info("Showing Modal");
		this.setState({ modalOpen: true });
	}
	private closeModal = () => {
		Logger.info("Hiding Modal");
		this.setState({ modalOpen: false });
	}

	private resetStateRatings = () => this.setState({ ratings: this.generateInitialRatings() }, () => {
		toast.success("Ratings reset");
	})

	private generateInitialRatings = () => {
		const ratings: any = {};
		for (let i = 1; i <= 20; i++) {
			ratings[`book${i}`] = undefined;
		}
		return ratings;
	}

	private generateRatingsResults = (recomendations: any) => {
		const keysArray = Object.keys(recomendations);
		if (keysArray.length > 0) {
			return keysArray.map((key: string) => (
				<div key={ key } style={{ display: "inline-table", width: 170, padding: 10 }}>
					<img src={ require(`../../books/mini/min${key}.png`)} height={150}/>
					<Rating book={ key } rating={ recomendations[key][0] } readonly noReset/>
				</div>
			));
		} else {
			return (
				<div style={ { color: "#AEAEAE", maxWidth: 450, margin: "auto" } }>
					Please rate some books and submit.<br/>
					The more accurate you are with your ratings,
					the more accurate the analysis will be with your results.
				</div>
			);
		}
	}

	private generateBookRatings = () => {
		const { ratings } = this.state;

		return Object.keys(ratings).map((key: string) => (
			<div key={ key } style={ { display: "inline-table", width: 170, padding: 10 } }>
				<img src={ require(`../../books/mini/min${key}.png`)} height={150}/>
				<Rating book={ key } rating={ ratings[key] } onChange={ this.newRatingChange }/>
			</div>
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
		let count = 0;
		const data = objectMap(ratings, (value: string) => {
			if (typeof value === "undefined") {
				count++;
				return null;
			} else {
				return parseInt(value, 10);
			}
		});

		if (count !== Object.keys(ratings).length) {
			fetch(`${baseUrl}/ratings`, {
				body: JSON.stringify(data),
				method: "POST",
			}).then(
				(value) => {
					value.json().then(
						(result) => {
							Logger.info(result);
							Logger.info(typeof(result));
							this.setState({ recomendations: result });
						},
						(error) => Logger.info(error),
					);
				},
				(error) => Logger.info(error),
			);
		} else {
			Logger.error("No rating given");
			toast.error("You need to rate some of the books before submitting");
		}
	}
}
