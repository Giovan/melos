module.exports = {
		"extends": "google",
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
			"experimentalObjectRestSpread": true,
			"experimentalClassProperties": true
		},
		"rules": {
			"semi": 0,
			"object-curly-spacing": ["error", "always"],
			"indent": ["error", "tab"],
			"no-unused-vars": 1,
			"no-multiple-empty-lines": ["error", "never"]
		}
};
