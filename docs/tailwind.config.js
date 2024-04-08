module.exports = {
  content: [ // list all locations where Tailwind classes can appear
    './_drafts/**/*.html',
    './_includes/**/*.html',
    './_layouts/**/*.html',
    './_posts/*.md',
    './*.md',
    './*.html'
  ],
  plugins: [
    require('@tailwindcss/typography'),
  ]
}
