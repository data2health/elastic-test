<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="es" uri="http://uiowa.edu/elasticsearch"%>


<!DOCTYPE html>
<html lang="en-US">
<body>
	<h1>Testing</h1>
	<es:index propertyName="es_test">
		<es:filter fieldName="_index" termString="cd2h-clinical-trials" />
		<es:filter fieldName="overall_status.keyword" termString="Terminated Completed" delimiterPattern=" " />

		<es:aggregator displayName="index" fieldName="_index" />
		<es:aggregator displayName="status" fieldName="overall_status.keyword" />
		<es:aggregator displayName="type" fieldName="study_type.keyword" />

		<es:search queryString="covid" limitCriteria="10">
			<div style="float: left">
				<h2>Sources</h2>
				<ul>
				<es:indexNameIterator>
					<li><es:indexName/>
				</es:indexNameIterator>
				</ul>
				<h2>Aggregations</h2>
				<es:aggregationIterator>
					<es:aggregation>
						<p><es:aggregationName /></p>
						<ul>
							<es:aggregationTermIterator>
								<li><es:aggregationTerm /> (<es:aggregationTermCount />)
							</es:aggregationTermIterator>
						</ul>
					</es:aggregation>
				</es:aggregationIterator>
			</div>
			<div style="float: left">
				<h2>Results</h2>
				<ul>
					<es:searchIterator>
						<li><a href="<es:hit label="url" />"><es:hit label="label" /></a>
					</es:searchIterator>
				</ul>
			</div>
		</es:search>
	</es:index>
</body>

</html>
