module.exports = {
		"installedESLint": true,
		"ecmaFeatures": {
			"arrowFunctions": true,
			"binaryLiterals": true,
			"blockBindings": true,
			"classes": true,
			"defaultParams": true,
			"destructuring": true,
			"forOf": true,
			"generators": true,
			"modules": true,
			"objectLiteralComputedProperties": true,
			"objectLiteralDuplicateProperties": true,
			"objectLiteralShorthandMethods": true,
			"objectLiteralShorthandProperties": true,
			"octalLiterals": true,
			"regexUFlag": true,
			"regexYFlag": true,
			"restParams": true,
			"spread": true,
			"superInFunctions": true,
			"templateStrings": true,
			"unicodeCodePointEscapes": true,
			"globalReturn": true,
			"jsx": true,
			"experimentalObjectRestSpread": true
		},
		"plugins": [
			"react",
		],
		"extends": "google",
		"rules": {
			"semi": 0,
			"max-len": 0,
			"object-curly-spacing": [2, "always"],
			"indent": [2, "tab"],
			"no-unused-vars": 1,
			"one-var": 0,
			"one-var-declaration-per-line": 0,
			"no-multiple-empty-lines": 0,
			"no-negated-condition": 0,
			"arrow-parens": 0,
			"comma-dangle": 0,
			"camelcase": 0,
			"padded-blocks": 0,
			"eol-last": 0,
			"array-bracket-spacing": 0,
			// jsx rules
			"jsx-quotes" : 0,
			"react/display-name": 0,
			"react/forbid-prop-types": 0,
			"react/jsx-boolean-value": 1,
			"react/jsx-closing-bracket-location": 1,
			"react/jsx-curly-spacing": 0,
			"react/jsx-handler-names": 1,
			"react/jsx-indent-props": [1, "tab"],
			"react/jsx-indent": [1, "tab"],
			"react/jsx-key": 1,
			"react/jsx-max-props-per-line": 0,
			"react/jsx-no-bind": 0,
			"react/jsx-no-duplicate-props": 1,
			"react/jsx-no-literals": 0,
			"react/jsx-no-undef": 1,
			"react/jsx-pascal-case": 1,
			"react/jsx-sort-prop-types": 0,
			"react/jsx-sort-props": 0,
			"react/jsx-uses-react": 1,
			"react/jsx-uses-vars": 1,
			"react/no-danger": 1,
			"react/no-deprecated": 1,
			"react/no-did-mount-set-state": 1,
			"react/no-did-update-set-state": 0,
			"react/no-direct-mutation-state": 1,
			"react/no-is-mounted": 1,
			"react/no-multi-comp": 0,
			"react/no-set-state": 0,
			"react/no-string-refs": 0,
			"react/no-unknown-property": 1,
			"react/prefer-es6-class": 1,
			"react/prop-types": 1,
			"react/react-in-jsx-scope": 1,
			"react/require-extension": 1,
			"react/self-closing-comp": 1,
			"react/sort-comp": 1,
			"react/wrap-multilines": 1
		}
};