import * as React from "react";

import { Link } from "gatsby";

import Container from "../components/Container";
import Page from "../components/Page";
import IndexLayout from "../layouts";

const NotFoundPage = () => (
	<IndexLayout>
		<Page>
			<Container>
				<h1>404: Page not found.</h1>
				<p>
					You've hit the void. <Link to="/">Go back.</Link>
				</p>
			</Container>
		</Page>
	</IndexLayout>
);

export default NotFoundPage;
