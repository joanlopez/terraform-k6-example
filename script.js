import {browser} from 'k6/browser';
import {check} from 'k6';

export const options = {
	thresholds: {
		checks: ['rate==1.0'],
	},
	scenarios: {
		default: {
			executor: 'constant-vus',
			vus: 10,
			duration: '10s',
			options: {
				browser: {
					type: 'chromium',
				},
			},
		},
	},
};

export default async function () {
	const context = await browser.newContext();
	const page = await context.newPage();

	try {
		// Navigate to the site
		await page.goto('https://joanlopez.github.io/terraform-k6-example/');

		// Get the page content
		const content = await page.content();

		// Check it contains the title
		check(content, {
			'the title is displayed': (html) => html.includes('Terraform k6 example'),
		});
	} finally {
		await page.close();
	}
}