import * as React from "react";

import BookBuyer from "../components/BookBuyer";
import BookRater from "../components/BookRater";

import Container from "../components/Container";
import Page from "../components/Page";
import IndexLayout from "../layouts";

if (process.env.NODE_ENV !== "production") {
	localStorage.setItem("debug", "book_store:*");
}

const IndexPage = () => (
	<IndexLayout>
		<Page>
			<Container>
				<BookBuyer />
				<BookRater />
			</Container>
		</Page>
	</IndexLayout>
);

export default IndexPage;
