// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
module.exports = {
    content: [
      './js/**/*.js',
      '../lib/*_web.ex',
      '../lib/*_web/**/*.*ex'
    ],
    theme: {
      extend: {},
    },
    plugins: [
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
        require('@tailwindcss/aspect-ratio'),
        function({ addVariant, e }) {
          addVariant('first-child', ({ modifySelectors, separator }) => {
            modifySelectors(({ className }) => {
              return `.${e(`first-child${separator}${className}`)}:first-child`
            })
          })
      },
      function({ addVariant, e }) {
        addVariant('last-child', ({ modifySelectors, separator }) => {
          modifySelectors(({ className }) => {
            return `.${e(`last-child${separator}${className}`)}:last-child`
          })
        })
      }
    ]
  }
  