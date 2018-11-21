import * as React from "react";
import Rating from "react-rating";

interface RatingWrapperProps {
	onChange: any
	book: string
	rating: number | undefined
}

const RatingWrapper = (props: RatingWrapperProps) => {
	const ratingChange = (rating: number) => props.onChange(props.book, rating);
	return (
		<div>
			<Rating key={ props.book } initialRating={ props.rating} onChange={ ratingChange }/>
			<button onClick={ () => props.onChange(props.book, undefined)}>reset</button>
		</div>
	);
};

export default RatingWrapper;
