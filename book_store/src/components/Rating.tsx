import * as React from "react";

interface PageProps {
	onChange: any;
	value: string;
	name: string;
}

const Rating: React.SFC<PageProps> = (props) => (
	<div>
		{ props.name }:
		<select {...props} >
			<option value="null">null</option>
			<option value="1">1</option>
			<option value="2">2</option>
			<option value="3">3</option>
			<option value="4">4</option>
			<option value="5">5</option>
		</select>
	</div>
);

export default Rating;
