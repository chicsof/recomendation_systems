import * as React from "react";
import Rating from "react-rating";

interface RatingWrapperProps {
	onChange?: any
	readonly?: boolean
	noReset?: boolean
	book: string
	rating: number | undefined
	style?: React.CSSProperties
}

const RatingWrapper = (props: RatingWrapperProps) => {
	const ratingChange = (rating: number) => props.onChange(props.book, rating);
	const getReset = () => {
		if (! props.noReset) {
			return <button onClick={ () => props.onChange(props.book, undefined)}>reset</button>;
		}
	};

	const readonly: boolean = props.readonly || false;
	return (
		<div style={props.style}>
			<Rating key={ props.book } initialRating={ props.rating} onChange={ ratingChange } readonly={ readonly }/>
			{ getReset() }
		</div>
	);
};

export default RatingWrapper;
