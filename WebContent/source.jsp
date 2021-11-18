<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="es" uri="http://uiowa.edu/elasticsearch"%>


<!DOCTYPE html>
<html lang="en-US">
<jsp:include page="head.jsp" flush="true">
	<jsp:param name="title" value="CTSAsearch" />
</jsp:include>
<style type="text/css" media="all">
@import "resources/layout.css";
</style>

<body class="home page-template-default page page-id-6 CD2H">
	<jsp:include page="header.jsp" flush="true" />

	<div class="container-fluid"
		style="padding-left: 5%; padding-right: 5%;">
		<br /> <br />
		<es:index propertyName="es_test">
			<es:searchField boost="4" fieldName="url" />
			<es:search queryString="${param.url}" limitCriteria="1000">
				<pre>
					<code>
					<es:searchIterator>
<es:document />
					</es:searchIterator>
				</code>
				</pre>
			</es:search>
		</es:index>
		<div style="width: 100%; float: left">
			<jsp:include page="footer.jsp" flush="true" />
		</div>
	</div>
</body>

</html>
