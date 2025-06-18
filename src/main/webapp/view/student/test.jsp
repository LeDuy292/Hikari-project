<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bài kiểm tra - HIKARI</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/test_student.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css" />
        <script src="${pageContext.request.contextPath}/assets/js/student_js/quiz.js?v=1"></script>
    </head>
    <body class="bg-gray-50">
        <div class="flex min-h-screen">
            <!-- Sidebar -->
            <%@ include file="sidebar.jsp" %>
            <!-- Main Content -->
            <div class="flex-1 ml-64 flex flex-col">
                <!-- Header -->
                <%@ include file="header.jsp" %>
                <!-- Test Content -->
                <div class="flex flex-grow p-10 gap-10">
                    <!-- Questions Area -->
                    <main class="w-2/3">
                        <div class="question-card">
                            <div class="text-lg font-semibold mb-4">Câu 1</div>
                            <p class="text-gray-700 mb-4">How did the ____ broken?</p>
                            <div class="space-y-3">
                                <label class="option-label"><input type="radio" name="q1" value="became" class="option-input"> Became</label>
                                <label class="option-label"><input type="radio" name="q1" value="was" class="option-input"> Was</label>
                                <label class="option-label"><input type="radio" name="q1" value="be" class="option-input"> Be</label>
                                <label class="option-label"><input type="radio" name="q1" value="get" class="option-input"> Get</label>
                            </div>
                        </div>
                        <div class="question-card">
                            <div class="text-lg font-semibold mb-4">Câu 2</div>
                            <p class="text-gray-700 mb-4">He drives quite ____, but his brother drives really ____.</p>
                            <div class="space-y-3">
                                <label class="option-label"><input type="radio" name="q2" value="slowly - really" class="option-input"> Slowly - really</label>
                                <label class="option-label"><input type="radio" name="q2" value="slow - fast" class="option-input"> Slow - fast</label>
                                <label class="option-label"><input type="radio" name="q2" value="slowly - fastly" class="option-input"> Slowly - fastly</label>
                                <label class="option-label"><input type="radio" name="q2" value="slowly - slowly" class="option-input"> Slowly - slowly</label>
                            </div>
                        </div>
                        <div class="question-card">
                            <div class="text-lg font-semibold mb-4">Câu 3</div>
                            <p class="text-gray-700 mb-4">She's wearing a ____ dress.</p>
                            <div class="space-y-3">
                                <label class="option-label"><input type="radio" name="q3" value="black long beautiful" class="option-input"> Black long beautiful</label>
                                <label class="option-label"><input type="radio" name="q3" value="long beautiful black" class="option-input"> Long beautiful black</label>
                                <label class="option-label"><input type="radio" name="q3" value="beautiful long black" class="option-input"> Beautiful long black</label>
                                <label class="option-label"><input type="radio" name="q3" value="long black beautiful" class="option-input"> Long black beautiful</label>
                            </div>
                        </div>
                        <div class="question-card">
                            <div class="text-lg font-semibold mb-4">Câu 4</div>
                            <p class="text-gray-700 mb-4">We took off our clothes and ____ into the river.</p>
                            <div class="space-y-3">
                                <label class="option-label"><input type="radio" name="q4" value="were jumping" class="option-input"> Were jumping</label>
                                <label class="option-label"><input type="radio" name="q4" value="had jumped" class="option-input"> Had jumped</label>
                                <label class="option-label"><input type="radio" name="q4" value="jumped" class="option-input"> Jumped</label>
                            </div>
                        </div>
                    </main>
                    <!-- Timer and Navigation Area -->
                    <aside class="w-1/3">
                        <div class="timer-panel">
                            <div class="text-center text-gray-700 font-semibold text-lg">Thời gian còn lại</div>
                            <div id="timer-display" class="text-center text-orange-500 font-bold text-6xl mt-2"></div>

                            <div class="text-gray-700 font-semibold mt-6 mb-3">Danh sách câu hỏi</div>
                            <div class="question-number-grid">
                                <div class="question-number-item text-gray-700"><span class="text-lg">1</span><span class="dot answered"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">2</span><span class="dot answered"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">3</span><span class="dot answered"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">4</span><span class="dot answered"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">5</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">6</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">7</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">8</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">9</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">10</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">11</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">12</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">13</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">14</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">15</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">16</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">17</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">18</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">19</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">20</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">21</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">22</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">23</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">24</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">25</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">26</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">27</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">28</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">29</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">30</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">31</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">32</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">33</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">34</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">35</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">36</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">37</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">38</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">39</span><span class="dot"></span></div>
                                <div class="question-number-item text-gray-700"><span class="text-lg">40</span><span class="dot"></span></div>
                            </div>
                            <div class="flex flex-col gap-4 mt-6">
                                <button class="w-full bg-gray-200 text-gray-700 px-4 py-2 rounded-lg font-semibold hover:bg-gray-300 transition">Quay lại trang trước</button>
                                <button id="submit-button" class="w-full bg-orange-500 text-white px-4 py-2 rounded-lg font-semibold shadow hover:bg-orange-600 transition">Nộp bài</button>
                            </div>
                        </div>
                    </aside>
                </div>
                <!-- Footer -->
                <%@ include file="footer.jsp" %>
            </div>
        </div>
    </body>
</html>