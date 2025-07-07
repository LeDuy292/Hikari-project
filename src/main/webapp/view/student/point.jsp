<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả Bài Test</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #e0e7ff 0%, #f3f4f6 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .card {
            border-radius: 24px;
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.1);
            background: white;
            padding: 40px;
            max-width: 800px;
            width: 90%;
            text-align: center;
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .score-circle {
            width: 100px;
            height: 100px;
            position: relative;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 20px;
            font-weight: 600;
            color: #1f2937;
        }
        .score-circle svg {
            position: absolute;
            width: 100%;
            height: 100%;
            transform: rotate(-90deg);
        }
        .score-circle .bg-circle {
            fill: none;
            stroke: #e5e7eb;
            stroke-width: 10;
        }
        .score-circle .progress-circle {
            fill: none;
            stroke: #10b981;
            stroke-width: 10;
            stroke-linecap: round;
            stroke-dasharray: 283;
            stroke-dashoffset: 283;
            transition: stroke-dashoffset 1s ease;
        }
        .score-circle.kanji .progress-circle { stroke-dashoffset: calc(283 - (283 * 5 / 20)); }
        .score-circle.tuvung .progress-circle { stroke-dashoffset: calc(283 - (283 * 0 / 40)); }
        .score-circle.nguphap .progress-circle { stroke-dashoffset: calc(283 - (283 * 0 / 40)); }
        .score-circle.dochieu .progress-circle { stroke-dashoffset: calc(283 - (283 * 0 / 40)); }
        .score-circle.nghehieu .progress-circle { stroke-dashoffset: calc(283 - (283 * 0 / 40)); }
        .total-score {
            background: linear-gradient(135deg, #facc15 0%, #f59e0b 100%);
            transition: transform 0.3s ease;
        }
        .total-score:hover {
            transform: scale(1.1);
        }
        .button-hover {
            background: linear-gradient(135deg, #f97316 0%, #ea580c 100%);
            transition: all 0.3s ease;
        }
        .button-hover:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(249, 115, 22, 0.4);
            background: linear-gradient(135deg, #fb923c 0%, #f97316 100%);
        }
        .section-title {
            background: linear-gradient(to right, #3b82f6, #10b981);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="flex justify-between items-start mb-10">
            <div class="text-left">
                <h2 class="text-3xl font-bold text-gray-800">Kết quả</h2>
                <p class="text-gray-500 mt-1">Bài test kiểm tra</p>
            </div>
            <div class="flex flex-col items-center">
                <div class="total-score w-28 h-28 rounded-full flex items-center justify-center text-gray-800 text-2xl font-bold shadow">
                    5/180
                </div>
                <div class="mt-3 text-gray-500 text-sm font-medium">
                    Tổng điểm
                </div>
            </div>
            <div class="text-right">
                <h3 class="text-xl font-semibold text-gray-800">Đề Thi Thử N5</h3>
                <p class="text-sm text-gray-500 mt-1">22-05-2025 15:42</p>
            </div>
        </div>

        <div class="border-t border-gray-200 pt-8 mb-8">
            <h3 class="section-title text-2xl font-bold mb-8">Tổng quan kỹ năng</h3>
            <div class="flex justify-around items-center flex-wrap gap-8">
                <div class="flex flex-col items-center">
                    <div class="score-circle kanji">
                        <svg>
                            <circle class="bg-circle" cx="50" cy="50" r="45"></circle>
                            <circle class="progress-circle" cx="50" cy="50" r="45"></circle>
                        </svg>
                        5/20
                    </div>
                    <div class="mt-3 text-gray-600 text-sm font-medium">Kanji</div>
                </div>
                <div class="flex flex-col items-center">
                    <div class="score-circle tuvung">
                        <svg>
                            <circle class="bg-circle" cx="50" cy="50" r="45"></circle>
                            <circle class="progress-circle" cx="50" cy="50" r="45"></circle>
                        </svg>
                        0/40
                    </div>
                    <div class="mt-3 text-gray-600 text-sm font-medium">Từ vựng</div>
                </div>
                <div class="flex flex-col items-center">
                    <div class="score-circle nguphap">
                        <svg>
                            <circle class="bg-circle" cx="50" cy="50" r="45"></circle>
                            <circle class="progress-circle" cx="50" cy="50" r="45"></circle>
                        </svg>
                        0/40
                    </div>
                    <div class="mt-3 text-gray-600 text-sm font-medium">Ngữ pháp</div>
                </div>
                <div class="flex flex-col items-center">
                    <div class="score-circle dochieu">
                        <svg>
                            <circle class="bg-circle" cx="50" cy="50" r="45"></circle>
                            <circle class="progress-circle" cx="50" cy="50" r="45"></circle>
                        </svg>
                        0/40
                    </div>
                    <div class="mt-3 text-gray-600 text-sm font-medium">Đọc hiểu</div>
                </div>
                <div class="flex flex-col items-center">
                    <div class="score-circle nghehieu">
                        <svg>
                            <circle class="bg-circle" cx="50" cy="50" r="45"></circle>
                            <circle class="progress-circle" cx="50" cy="50" r="45"></circle>
                        </svg>
                        0/40
                    </div>
                    <div class="mt-3 text-gray-600 text-sm font-medium">Nghe hiểu</div>
                </div>
            </div>
        </div>

        <button class="button-hover mt-10 bg-orange-500 text-white px-10 py-4 rounded-full font-semibold shadow text-lg">
            NHẬN TƯ VẤN LỘ TRÌNH
        </button>
    </div>
</body>
</html>