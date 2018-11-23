import * as React from "react";

import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

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
			<ToastContainer />
			<Container>
				<BookBuyer />
				<BookRater />
			</Container>
		</Page>
	</IndexLayout>
);

export default IndexPage;
