<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Từ điển Nhật - Việt | HIKARI</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/sidebar_student.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/header_student.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/student_css/footer_student.css">
    <style>
        /* Fix sidebar underline issue */
        .sidebar a, .sidebar .menu-item {
            text-decoration: none !important;
        }
        
        .sidebar a:hover, .sidebar .menu-item:hover {
            text-decoration: none !important;
        }
        
        /* Custom header alignment for dictionary page */
        .main-header {
            justify-content: flex-end !important;
            padding: 32px 48px 0 0 !important;
        }
        
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        
        .page-wrapper {
            display: flex;
            flex: 1;
        }
        
        .main-content {
            margin-left: 280px;
            padding: 0;
            width: calc(100% - 280px);
            flex: 1;
            background: #f8f9fa;
        }
        
        .content-wrapper {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .dictionary-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .dictionary-header {
            background: linear-gradient(135deg, #ff9800 0%, #ffb347 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
            position: relative;
        }
        
        .dictionary-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
            opacity: 0.3;
        }
        
        .dictionary-header h1 {
            font-size: 32px;
            margin: 0 0 10px 0;
            font-weight: 700;
            position: relative;
            z-index: 1;
        }
        
        .dictionary-header p {
            font-size: 16px;
            margin: 0;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }
        
        .search-section {
            padding: 40px 30px;
            background: white;
        }
        
        .search-container {
            max-width: 600px;
            margin: 0 auto;
        }
        
        .search-box {
            display: flex;
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }
        
        .search-box:focus-within {
            border-color: #ff9800;
            box-shadow: 0 4px 20px rgba(255, 152, 0, 0.2);
        }
        
        .search-input {
            flex: 1;
            padding: 18px 24px;
            font-size: 16px;
            border: none;
            outline: none;
            background: transparent;
        }
        
        .search-input::placeholder {
            color: #999;
        }
        
        .search-btn {
            padding: 18px 30px;
            background: linear-gradient(135deg, #ff9800, #ffb347);
            color: white;
            border: none;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            min-width: 120px;
            justify-content: center;
        }
        
        .search-btn:hover:not(:disabled) {
            background: linear-gradient(135deg, #e68900, #ff9800);
            transform: translateY(-1px);
        }
        
        .search-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }
        
        .loading-spinner {
            display: none;
            width: 20px;
            height: 20px;
            border: 2px solid #ffffff;
            border-top: 2px solid transparent;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .results-section {
            padding: 0 30px 30px;
        }
        
        .result-item {
            border: 1px solid #e8e8e8;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            background: #fafafa;
            transition: all 0.3s ease;
        }
        
        .result-item:hover {
            box-shadow: 0 6px 25px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
            border-color: #ff9800;
        }
        
        .result-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .word-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .result-word {
            font-size: 28px;
            font-weight: 700;
            color: #333;
        }
        
        .result-reading {
            font-size: 18px;
            color: #ff9800;
            font-style: italic;
            background: #fff7ed;
            padding: 4px 12px;
            border-radius: 20px;
        }
        
        .audio-controls {
            display: flex;
            gap: 10px;
        }
        
        .play-audio {
            background: linear-gradient(135deg, #ff9800, #ffb347);
            border: none;
            border-radius: 50%;
            width: 45px;
            height: 45px;
            cursor: pointer;
            color: white;
            font-size: 18px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 8px rgba(255, 152, 0, 0.3);
        }
        
        .play-audio:hover {
            background: linear-gradient(135deg, #e68900, #ff9800);
            transform: scale(1.1);
            box-shadow: 0 4px 15px rgba(255, 152, 0, 0.4);
        }
        
        .definitions {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .definitions li {
            margin-bottom: 18px;
            padding: 20px;
            background: white;
            border-radius: 10px;
            border-left: 4px solid #ff9800;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }
        
        .definition-number {
            color: #ff9800;
            font-weight: 700;
            font-size: 16px;
            margin-right: 12px;
        }
        
        .english-def {
            color: #333;
            margin-bottom: 10px;
            font-size: 15px;
            line-height: 1.5;
        }
        
        .vietnamese-def {
            color: #555;
            font-style: italic;
            font-size: 15px;
            background: #f8f9fa;
            padding: 12px;
            border-radius: 6px;
            margin-top: 8px;
            border-left: 3px solid #28a745;
        }
        
        .parts-of-speech {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1565c0;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            margin-left: 10px;
            font-weight: 600;
            display: inline-block;
            margin-top: 8px;
        }
        
        .recent-section {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            padding: 30px;
            margin-top: 30px;
        }
        
        .recent-title {
            font-size: 22px;
            font-weight: 700;
            color: #333;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .recent-title i {
            color: #ff9800;
            font-size: 24px;
        }
        
        .recent-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 15px;
        }
        
        .recent-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 20px;
            background: #f8f9fa;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid #e8e8e8;
        }
        
        .recent-item:hover {
            background: #fff7ed;
            border-color: #ff9800;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 152, 0, 0.15);
        }
        
        .recent-keyword {
            font-weight: 600;
            color: #333;
        }
        
        .search-time {
            font-size: 12px;
            color: #666;
            opacity: 0.8;
        }
        
        .error-message {
            color: #dc3545;
            text-align: center;
            margin: 30px 0;
            font-style: italic;
            padding: 25px;
            background: #fff5f5;
            border-radius: 12px;
            border: 1px solid #fecaca;
            font-size: 16px;
        }
        
        .no-results {
            text-align: center;
            color: #666;
            margin-top: 40px;
            font-style: italic;
            padding: 50px;
            background: #f9fafb;
            border-radius: 16px;
        }
        
        .no-results i {
            font-size: 64px;
            color: #d1d5db;
            margin-bottom: 20px;
            display: block;
        }
        
        .no-results h3 {
            margin: 15px 0;
            color: #374151;
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                width: 100%;
            }
            
            .content-wrapper {
                padding: 15px;
            }
            
            .dictionary-header {
                padding: 30px 20px;
            }
            
            .dictionary-header h1 {
                font-size: 24px;
            }
            
            .search-section {
                padding: 30px 20px;
            }
            
            .result-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .word-info {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .recent-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="page-wrapper">
        <jsp:include page="sidebar.jsp" />

        <div class="main-content">
            <!-- Include Header with right alignment -->
            <jsp:include page="header.jsp" />
            
            <div class="content-wrapper">
                <div class="dictionary-container">
                    <!-- Dictionary Header -->
                    <div class="dictionary-header">
                        <h1><i class="fas fa-book-open"></i> HIKARI Từ điển Nhật - Việt</h1>
                        <p>Tra cứu từ vựng tiếng Nhật và tiếng Việt nhanh chóng, chính xác</p>
                    </div>

                    <!-- Search Section -->
                    <div class="search-section">
                        <div class="search-container">
                            <form action="${pageContext.request.contextPath}/dictionary" method="get" class="search-box" id="searchForm">
                                <input type="text" name="keyword" class="search-input" id="searchInput"
                                       placeholder="Nhập từ tiếng Nhật hoặc tiếng Việt..." 
                                       value="${keyword != null ? keyword : ''}"
                                       autocomplete="off">
                                <button type="submit" class="search-btn" id="searchBtn">
                                    <span class="search-text">
                                        <i class="fas fa-search"></i>
                                        Tra cứu
                                    </span>
                                    <div class="loading-spinner"></div>
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- Error Message -->
                    <c:if test="${not empty errorMessage}">
                        <div class="results-section">
                            <div class="error-message">
                                <i class="fas fa-exclamation-triangle"></i>
                                ${errorMessage}
                            </div>
                        </div>
                    </c:if>

                    <!-- Search Results -->
                    <c:if test="${not empty results}">
                        <div class="results-section">
                            <c:forEach var="entry" items="${results}">
                                <div class="result-item">
                                    <div class="result-header">
                                        <div class="word-info">
                                            <span class="result-word">
                                                <c:if test="${not empty entry.japanese[0].word}">
                                                    ${entry.japanese[0].word}
                                                </c:if>
                                                <c:if test="${empty entry.japanese[0].word && not empty entry.japanese[0].reading}">
                                                    ${entry.japanese[0].reading}
                                                </c:if>
                                            </span>
                                            <c:if test="${not empty entry.japanese[0].reading && not empty entry.japanese[0].word}">
                                                <span class="result-reading">${entry.japanese[0].reading}</span>
                                            </c:if>
                                        </div>
                                        <div class="audio-controls">
                                            <button class="play-audio" 
                                                    onclick="playJapaneseAudio('${entry.japanese[0].reading != null ? entry.japanese[0].reading : entry.japanese[0].word}')"
                                                    title="Nghe phát âm tiếng Nhật">
                                                <i class="fas fa-volume-up"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <ul class="definitions">
                                        <c:forEach var="sense" items="${entry.senses}" varStatus="loop">
                                            <li>
                                                <span class="definition-number">${loop.index + 1}.</span>
                                                <div class="english-def">
                                                    <strong>🇺🇸 Tiếng Anh:</strong>
                                                    <c:forEach var="def" items="${sense.english_definitions}" varStatus="defLoop">
                                                        ${def}<c:if test="${!defLoop.last}">; </c:if>
                                                    </c:forEach>
                                                </div>
                                                <c:if test="${not empty sense.vietnamese_definitions}">
                                                    <div class="vietnamese-def">
                                                        <strong>🇻🇳 Tiếng Việt:</strong>
                                                        <c:forEach var="viDef" items="${sense.vietnamese_definitions}" varStatus="viDefLoop">
                                                            ${viDef}<c:if test="${!viDefLoop.last}">; </c:if>
                                                        </c:forEach>
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty sense.parts_of_speech}">
                                                    <div style="margin-top: 12px;">
                                                        <c:forEach var="pos" items="${sense.parts_of_speech}">
                                                            <span class="parts-of-speech">${pos}</span>
                                                        </c:forEach>
                                                    </div>
                                                </c:if>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <!-- No Results -->
                    <c:if test="${empty results && not empty keyword && empty errorMessage}">
                        <div class="results-section">
                            <div class="no-results">
                                <i class="fas fa-search"></i>
                                <h3>Không tìm thấy kết quả</h3>
                                <p>Không tìm thấy kết quả cho từ khóa: <strong>"${keyword}"</strong></p>
                                <p>Vui lòng thử lại với từ khóa khác.</p>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Recent Searches -->
                <div class="recent-section">
                    <div class="recent-title">
                        <i class="fas fa-history"></i>
                        Từ đã tra gần đây
                    </div>
                    <c:if test="${not empty recentSearches}">
                        <div class="recent-grid">
                            <c:forEach var="history" items="${recentSearches}">
                                <div class="recent-item" onclick="searchWord('${history.keyword}')">
                                    <span class="recent-keyword">${history.keyword}</span>
                                    <span class="search-time">
                                        ${fn:replace(fn:replace(fn:substring(history.searchTime.toString(), 0, 16), 'T', ' '), '-', '/')}
                                    </span>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                    <c:if test="${empty recentSearches}">
                        <div class="no-results">
                            <i class="fas fa-search"></i>
                            <p>Chưa có từ nào được tra cứu gần đây.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Include Footer -->

    <script>
        function playJapaneseAudio(text) {
            if ('speechSynthesis' in window && text && text.trim()) {
                speechSynthesis.cancel();
                
                const utterance = new SpeechSynthesisUtterance(text);
                utterance.lang = 'ja-JP';
                utterance.rate = 0.7;
                utterance.pitch = 1;
                utterance.volume = 1;
                
                utterance.onerror = function(event) {
                    console.error('Lỗi phát âm:', event.error);
                    alert('Không thể phát âm từ này. Vui lòng thử lại.');
                };
                
                speechSynthesis.speak(utterance);
            } else {
                alert('Trình duyệt không hỗ trợ phát âm hoặc từ khóa rỗng.');
            }
        }

        function searchWord(keyword) {
            if (keyword && keyword.trim()) {
                document.getElementById('searchInput').value = keyword;
                document.getElementById('searchForm').submit();
            }
        }

        // Handle form submission with loading state
        document.addEventListener('DOMContentLoaded', function() {
            const searchForm = document.getElementById('searchForm');
            const searchInput = document.getElementById('searchInput');
            const searchBtn = document.getElementById('searchBtn');
            const searchText = searchBtn.querySelector('.search-text');
            const loadingSpinner = searchBtn.querySelector('.loading-spinner');
            
            if (searchForm && searchInput && searchBtn) {
                searchForm.addEventListener('submit', function(e) {
                    const keyword = searchInput.value.trim();
                    if (!keyword) {
                        e.preventDefault();
                        alert('Vui lòng nhập từ khóa để tra cứu.');
                        searchInput.focus();
                        return;
                    }
                    
                    // Show loading state
                    searchBtn.disabled = true;
                    searchText.style.display = 'none';
                    loadingSpinner.style.display = 'block';
                    
                    // Set timeout to prevent infinite loading
                    setTimeout(function() {
                        if (searchBtn.disabled) {
                            searchBtn.disabled = false;
                            searchText.style.display = 'flex';
                            loadingSpinner.style.display = 'none';
                        }
                    }, 10000); // 10 seconds timeout
                });
                
                // Focus on input when page loads
                searchInput.focus();
            }
        });

        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            if (e.ctrlKey && e.key === 'k') {
                e.preventDefault();
                document.getElementById('searchInput').focus();
            }
        });
    </script>
</body>
</html>
