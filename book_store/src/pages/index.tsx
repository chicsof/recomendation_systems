import * as React from "react";

import { BarLoader } from "react-spinners";
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

const loaderStyle: React.CSSProperties = {
	background: "#DDD",
	borderRadius: "5px",
	boxShadow: "0px 0px 0px 500vh rgba(0,0,0,0.25)",
	left: "50%",
	padding: "15px",
	position: "fixed",
	top: "50%",
	transform: "translate(-50%, -50%)",
};

const IndexPage = () => (
	<IndexLayout>
		<Page>
			<ToastContainer />
			<Container>
				<BookBuyer />
				<BookRater />
				{/*
				<div style={loaderStyle}>
					<BarLoader height={4} width={245} color={"#87c64f"} />
				</div>
				*/}
			</Container>
		</Page>
	</IndexLayout>
);

export default IndexPage;
