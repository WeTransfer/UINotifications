# Import the shared Danger file from Rabbit to share common Danger configuration
danger.import_dangerfile(path: "danger/shared/")

## Let's check if there are any changes in the project folder
has_app_changes = !git.modified_files.grep(/Sources/).empty?
## Then, we should check if tests are updated
has_test_changes = !git.modified_files.grep("/Tests/").empty?

## Finally, let's combine them and put extra condition 
## for changed number of lines of code
if has_app_changes && !has_test_changes && git.lines_of_code > 20
	warn("The library files were changed, but the tests remained unmodified. Consider updating or adding to the tests to match the library changes.", sticky: false)
end

# Changelog entries are required for changes to library files.
no_changelog_entry = !git.modified_files.include?("Changelog.md")
if has_app_changes && no_changelog_entry && not_declared_trivial
  warn("Any changes to library code should be reflected in the Changelog. Please consider adding a note there.")
end

# Show Code coverage report
xcov.report(
	scheme: 'UINotifications-Example',
	minimum_coverage_percentage: 80,
	only_project_targets: true,
	output_directory: "xcov_output"
)

# Run SwiftLint
swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files inline_mode: true