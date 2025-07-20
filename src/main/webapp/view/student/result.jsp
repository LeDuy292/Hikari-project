<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>JLPT Test Result</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <style>
            .stat-card {
                background-color: #f9fafb;
                padding: 16px;
                border-radius: 8px;
                text-align: center;
            }
        </style>
    </head>
    <body class="bg-gray-100 font-sans">
        <div class="container mx-auto p-6">
            <h1 class="text-3xl font-bold text-center mb-6">${sessionScope.test.title} - Result</h1>
            <div class="bg-white p-6 rounded-lg shadow-md mb-6">
                <h2 class="text-xl font-semibold mb-4">Test Summary</h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="stat-card">
                        <h3 class="text-lg font-medium">Total Score</h3>
                        <p class="text-2xl font-bold">${sessionScope.score}/${sessionScope.test.totalMarks}</p>
                    </div>
                    <div class="stat-card">
                        <h3 class="text-lg font-medium">Time Taken</h3>
                        <p class="text-2xl font-bold">${sessionScope.timeTaken}</p>
                    </div>
                    <div class="stat-card">
                        <h3 class="text-lg font-medium">Status</h3>
                        <p class="text-2xl font-bold ${sessionScope.score >= sessionScope.test.totalMarks * 0.5 ? 'text-green-600' : 'text-red-600'}">
                            ${sessionScope.score >= sessionScope.test.totalMarks * 0.5 ? 'Pass' : 'Fail'}
                        </p>
                    </div>
                </div>
            </div>

            <div class="mt-6 text-center">
<!--                <a href="Test?action=viewResult&testId=${sessionScope.test.id}&index=0" 
                   class="bg-blue-500 text-white py-2 px-4 rounded-md hover:bg-blue-600 transition">
                    Review Answers
                </a>-->
                <a href="${pageContext.request.contextPath}/view/student/home.jsp" 
                   class="bg-gray-500 text-white py-2 px-4 rounded-md hover:bg-gray-600 transition">
                    Back to Home
                </a>
            </div>
        </div>
    </body>
</html>
