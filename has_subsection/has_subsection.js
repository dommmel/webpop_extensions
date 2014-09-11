exports.has_subsection = function(options, enclosed, scope) {
	var content = site.content({from: scope.id});
  return (content.sections().length > 0);
}
