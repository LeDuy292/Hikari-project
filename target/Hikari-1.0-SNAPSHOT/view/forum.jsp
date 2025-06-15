<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, dao.UserDAO, model.ForumPost, model.ForumComment, model.UserActivityScore, model.User, java.text.SimpleDateFormat, java.sql.Timestamp, dao.ForumPostDAO" %>
<%!
    public String escapeHtml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("'", "&#39;");
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Diễn Đàn Luyện Thi JLPT</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <style>
        :root {
            --primary: #4f8cff;
            --secondary: #232946;
            --accent: #f7c873;
            --bg: #f4f6fb;
            --card-bg: #fff;
            --shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.1);
            --radius: 18px;
            --transition: 0.25s cubic-bezier(0.4, 2, 0.6, 1);
            --like-color: #4f8cff;
            --comment-color: #9b59b6;
            --share-color: #1abc9c;
        }
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        body {
            font-family: "Segoe UI", "Roboto", Arial, sans-serif;
            background: var(--bg);
            min-height: 100vh;
            overflow-x: hidden;
        }
        .topbar {
            width: 100%;
            background: linear-gradient(90deg, var(--primary) 60%, var(--accent) 100%);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            height: 62px;
            box-shadow: 0 2px 12px rgba(79, 140, 255, 0.07);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .topbar .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.3rem;
            font-weight: 700;
            letter-spacing: 1px;
        }
        .topbar .logo-icon {
            width: 48px;
            height: 48px;
            border-radius: 8px;
            overflow: hidden;
        }
        .logo-icon .logo-img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }
        .topbar .nav {
            display: flex;
            gap: 24px;
            align-items: center;
        }
        .topbar .nav a {
            color: #fff;
            text-decoration: none;
            font-weight: 500;
            font-size: 1rem;
            padding: 8px 14px;
            border-radius: 8px;
            transition: background 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .topbar .nav a.active,
        .topbar .nav a:hover {
            background: rgba(255, 255, 255, 0.13);
        }
        .topbar .account-dropdown {
            position: relative;
        }
        .topbar .account-btn {
            background: none;
            border: none;
            color: #fff;
            font-size: 1rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            padding: 8px 14px;
            border-radius: 8px;
            transition: background 0.2s;
        }
        .topbar .account-btn:hover {
            background: rgba(255, 255, 255, 0.13);
        }
        .topbar .dropdown-menu {
            display: none;
            position: absolute;
            right: 0;
            top: 110%;
            background: #fff;
            color: var(--secondary);
            min-width: 160px;
            border-radius: 10px;
            box-shadow: 0 4px 24px rgba(31, 38, 135, 0.13);
            z-index: 10;
            overflow: hidden;
        }
        .topbar .dropdown-menu a {
            display: block;
            padding: 12px 18px;
            color: var(--secondary);
            text-decoration: none;
            font-weight: 500;
            transition: background 0.2s;
        }
        .topbar .dropdown-menu a:hover {
            background: var(--bg);
        }
        .topbar .account-dropdown.open .dropdown-menu {
            display: block;
        }
        .avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .avatar.sm {
            width: 24px;
            height: 24px;
        }
        .layout {
            display: flex;
            width: 100%;
            min-height: calc(100vh - 62px);
        }
        .sidebar-left {
            width: 260px;
            background: var(--card-bg);
            box-shadow: var(--shadow);
            padding: 32px 18px;
            position: fixed;
            top: 62px;
            left: 0;
            height: calc(100vh - 62px);
            overflow-y: auto;
            z-index: 50;
        }
        .sidebar-left .topics {
            margin-top: 0;
        }
        .sidebar-left .topics-title {
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 20px;
            font-size: 1.1em;
        }
        .sidebar-left .topic-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .sidebar-left .topic-list li {
            margin-bottom: 12px;
        }
        .sidebar-left .topic-list a {
            color: var(--secondary);
            text-decoration: none;
            font-size: 1em;
            padding: 12px 14px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: background 0.2s, color 0.2s;
        }
        .sidebar-left .topic-list a.active,
        .sidebar-left .topic-list a:hover {
            background: var(--primary);
            color: #fff;
        }
        .main-content {
            flex: 1;
            padding: 32px;
            margin-left: 260px;
        }
        .forum-toolbar {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 24px;
        }
        .forum-toolbar h1 {
            font-size: 1.5rem;
            color: var(--secondary);
        }
        .forum-toolbar .toolbar-actions {
            display: flex;
            gap: 16px;
            align-items: center;
            flex-wrap: wrap;
        }
        .forum-toolbar .filters {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .forum-toolbar select {
            border-radius: 8px;
            border: 1.5px solid #eaf1ff;
            padding: 10px 14px;
            font-size: 1em;
            background: #f9fbfc;
            color: var(--secondary);
            outline: none;
            transition: border 0.2s;
            min-width: 160px;
        }
        .forum-toolbar select:focus {
            border-color: var(--primary);
        }
        .post-list {
            display: flex;
            flex-direction: column;
            gap: 18px;
        }
        .post-card {
            background: var(--card-bg);
            border-radius: 14px;
            box-shadow: var(--shadow);
            padding: 20px 18px;
            display: flex;
            flex-direction: row;
            gap: 20px;
            transition: box-shadow 0.2s, transform 0.2s;
            position: relative;
        }
        .post-card:hover {
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.13);
            transform: translateY(-2px) scale(1.01);
        }
        .post-card .post-image {
            width: 200px;
            min-width: 200px;
            max-height: 150px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .post-card .post-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .post-card .post-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .post-card .post-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 4px;
        }
        .post-card .author-info {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        .post-card .author-name {
            font-weight: 600;
            color: var(--secondary);
            font-size: 1em;
        }
        .post-card .post-meta {
            display: flex;
            gap: 12px;
            align-items: center;
            color: #7f8c8d;
            font-size: 0.95em;
        }
        .post-card .post-title {
            font-size: 1.18em;
            font-weight: bold;
            color: var(--primary);
            margin-bottom: 8px;
            text-decoration: none;
            cursor: pointer;
            transition: color 0.2s;
        }
        .post-card .post-title:hover {
            color: var(--accent);
            text-decoration: underline;
        }
        .post-card .post-body {
            font-size: 1em;
            color: var(--secondary);
            line-height: 1.6;
            margin-bottom: 10px;
        }
        .post-card .post-tags {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-left: auto;
        }
        .post-card .tag {
            background: #eaf1ff;
            color: var(--primary);
            border-radius: 8px;
            padding: 4px 10px;
            font-size: 0.92em;
            font-weight: 500;
        }
        .post-card .post-actions {
            display: flex;
            gap: 18px;
            align-items: center;
            margin-top: 6px;
            justify-content: flex-end;
        }
        .post-card .action-btn {
            background: none;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 15px;
            transition: all 0.2s;
            font-size: 1em;
            font-weight: 500;
        }
        .post-card .action-btn.like-btn {
            color: #7f8c8d;
        }
        .post-card .action-btn.like-btn.liked {
            color: var(--like-color);
        }
        .post-card .action-btn.comment-btn {
            color: var(--comment-color);
        }
        .post-card .action-btn.share-btn {
            color: var(--share-color);
        }
        .post-card .action-btn:hover {
            background: #eaf1ff;
            transform: scale(1.05);
        }
        .comment-section {
            margin-top: 20px;
            padding: 10px;
            border-top: 1px solid #eee;
        }
        .comment {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }
        .comment-content {
            flex: 1;
        }
        .comment-time {
            font-size: 0.9em;
            color: #7f8c8d;
        }
        .comment-form {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }
        .comment-form textarea {
            flex: 1;
            padding: 10px;
            border: 1.5px solid #eaf1ff;
            border-radius: 8px;
            font-size: 1em;
        }
        .sidebar-right {
            width: 300px;
            background: var(--card-bg);
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 24px 18px;
            height: fit-content;
            margin-right: 24px;
            min-width: 220px;
            display: flex;
            flex-direction: column;
            gap: 22px;
            position: sticky;
            top: 90px;
        }
        .widget {
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 20px;
            margin-bottom: 20px;
        }
        .widget-title {
            font-size: 1.15em;
            color: var(--primary);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
        }
        .widget-image {
            width: 100%;
            height: 200px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .widget-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .top-users {
            list-style: none;
            padding: 0;
        }
        .top-user {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 0;
            border-radius: 10px;
            margin-bottom: 8px;
            transition: background 0.2s;
        }
        .top-user:hover {
            background: #f9fbfc;
        }
        .rank {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            background: linear-gradient(45deg, #f1c40f, #f7c873);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1em;
            color: #fff;
            box-shadow: 0 2px 8px rgba(247, 200, 115, 0.13);
        }
        .user-info {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        .user-name {
            font-weight: 600;
            color: var(--secondary);
        }
        .user-role {
            font-size: 0.85em;
            color: #7f8c8d;
        }
        .user-points {
            font-size: 0.85em;
            color: var(--primary);
        }
        .btn {
            padding: 10px 22px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: bold;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 1em;
        }
        .btn-primary {
            background: linear-gradient(90deg, var(--primary) 60%, var(--accent) 100%);
            color: #fff;
            box-shadow: 0 2px 8px rgba(79, 140, 255, 0.13);
        }
        .btn-primary:hover {
            background: linear-gradient(90deg, var(--accent) 60%, var(--primary) 100%);
            transform: translateY(-2px) scale(1.03);
        }
        .btn-blue {
            background: var(--primary);
            color: #fff;
        }
        .btn-blue:hover {
            background: #3a7bff;
        }
        .btn-yellow {
            background: var(--accent);
            color: var(--secondary);
        }
        .btn-yellow:hover {
            background: #f5bc5a;
        }
        .btn-block {
            display: block;
            width: 100%;
            text-align: center;
            margin-bottom: 10px;
        }
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease-in-out;
        }
        .modal-overlay.active {
            opacity: 1;
            visibility: visible;
        }
        .modal {
            background: linear-gradient(180deg, #ffffff 0%, #f9fbfc 100%);
            border-radius: 20px;
            width: 90%;
            max-width: 900px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
            transform: translateY(50px);
            transition: transform 0.4s ease-in-out, opacity 0.4s ease-in-out;
            opacity: 0;
        }
        .modal-overlay.active .modal {
            transform: translateY(0);
            opacity: 1;
        }
        .modal-header {
            padding: 20px 30px;
            border-bottom: 1px solid #f0f2f5;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(255, 255, 255, 0.95);
            position: sticky;
            top: 0;
            z-index: 10;
        }
        .modal-title {
            font-size: 1.8rem;
            color: var(--primary);
            margin: 0;
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        .modal-body {
            padding: 30px;
        }
        .modal-footer {
            padding: 15px 30px;
            border-top: 1px solid #f0f2f5;
            background: rgba(255, 255, 255, 0.95);
            position: sticky;
            bottom: 0;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--secondary);
        }
        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 1.5px solid #eaf1ff;
            border-radius: 8px;
            font-size: 1em;
            background: #f9fbfc;
            color: var(--secondary);
            outline: none;
            transition: border 0.2s, box-shadow 0.2s;
        }
        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 8px rgba(79, 140, 255, 0.2);
        }
        textarea.form-control {
            min-height: 120px;
            resize: vertical;
        }
        .image-upload {
            border: 1.5px dashed #eaf1ff;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: border-color 0.2s, background 0.2s;
        }
        .image-upload:hover {
            border-color: var(--primary);
            background: rgba(79, 140, 255, 0.05);
        }
        .image-upload input[type="file"] {
            display: none;
        }
        .image-preview {
            max-width: 100%;
            max-height: 200px;
            border-radius: 8px;
            margin-top: 10px;
        }
        .pagination {
            display: flex;
            gap: 10px;
            margin-top: 20px;
            justify-content: center;
        }
        .pagination a {
            padding: 8px 16px;
            border: 1px solid #eaf1ff;
            border-radius: 8px;
            text-decoration: none;
            color: var(--primary);
            transition: background 0.2s, transform 0.2s;
        }
        .pagination a:hover {
            background: #eaf1ff;
            transform: scale(1.05);
        }
        .alert {
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 8px;
            background: #d4edda;
            color: #155724;
        }
        .alert-success {
            background: #d4edda;
            color: #155724;
        }
        /* Enhanced styles for post detail modal */
        .post-detail-modal .modal {
            max-width: 900px;
            border: 1px solid rgba(79, 140, 255, 0.1);
            background: linear-gradient(180deg, #f9fbfc 0%, #ffffff 100%);
        }
        .post-detail-header {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-bottom: 20px;
        }
        .post-detail-header-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .post-detail-author {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .post-detail-author .avatar {
            width: 50px;
            height: 50px;
            border: 2px solid var(--primary);
            box-shadow: 0 2px 8px rgba(79, 140, 255, 0.2);
        }
        .post-detail-author-info {
            display: flex;
            flex-direction: column;
        }
        .post-detail-author-name {
            font-size: 1.2em;
            font-weight: 600;
            color: var(--secondary);
            cursor: pointer;
        }
        .post-detail-author-name:hover {
            color: var(--primary);
            text-decoration: underline;
        }
        .post-detail-time {
            font-size: 0.9em;
            color: #7f8c8d;
        }
        .post-detail-options {
            position: relative;
        }
        .post-detail-options-btn {
            background: none;
            border: none;
            color: #7f8c8d;
            font-size: 1.5em;
            cursor: pointer;
            transition: color 0.2s, transform 0.2s;
        }
        .post-detail-options-btn:hover {
            color: var(--primary);
            transform: scale(1.2);
        }
        .post-detail-options-menu {
            display: none;
            position: absolute;
            right: 0;
            top: 100%;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 24px rgba(31, 38, 135, 0.13);
            z-index: 10;
            min-width: 150px;
            overflow: hidden;
        }
        .post-detail-options.open .post-detail-options-menu {
            display: block;
        }
        .post-detail-options-menu a, .post-detail-options-menu button {
            display: block;
            padding: 12px 18px;
            color: var(--secondary);
            text-decoration: none;
            background: none;
            border: none;
            width: 100%;
            text-align: left;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s;
        }
        .post-detail-options-menu a:hover, .post-detail-options-menu button:hover {
            background: var(--bg);
        }
        .post-detail-image {
            width: 100%;
            max-height: 400px;
            border-radius: 16px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.3s ease;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 15px;
        }
        .post-detail-image:hover {
            transform: scale(1.02);
        }
        .post-detail-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .post-detail-image.placeholder {
            background: linear-gradient(45deg, #f0f2f5, #f9fbfc);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #7f8c8d;
            font-size: 1.2rem;
            font-weight: 500;
        }
        .post-detail-title {
            font-size: 1.8rem;
            font-weight: bold;
            color: var(--primary);
            margin-bottom: 10px;
        }
        .post-detail-content {
            font-size: 1.1em;
            line-height: 1.8;
            color: var(--secondary);
            margin-bottom: 20px;
            padding: 15px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        .post-detail-content a.hashtag {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }
        .post-detail-content a.hashtag:hover {
            text-decoration: underline;
        }
        .post-detail-interaction-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-top: 1px solid #f0f2f5;
            border-bottom: 1px solid #f0f2f5;
            margin-bottom: 20px;
        }
        .post-detail-interaction-stats {
            font-size: 0.95em;
            color: #7f8c8d;
        }
        .post-detail-interaction-buttons {
            display: flex;
            gap: 15px;
        }
        .post-detail-interaction-buttons .action-btn {
            background: none;
            border: none;
            color: #7f8c8d;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 8px 12px;
            border-radius: 10px;
            transition: all 0.2s;
            font-size: 1em;
            font-weight: 500;
        }
        .post-detail-interaction-buttons .like-btn {
            color: #7f8c8d;
        }
        .post-detail-interaction-buttons .like-btn.liked {
            color: var(--like-color);
        }
        .post-detail-interaction-buttons .comment-btn {
            color: var(--comment-color);
        }
        .post-detail-interaction-buttons .share-btn {
            color: var(--share-color);
        }
        .post-detail-interaction-buttons .action-btn:hover {
            background: #eaf1ff;
            transform: scale(1.05);
        }
        .post-detail-comment-section {
            margin-top: 20px;
        }
        .post-detail-comment {
            background: linear-gradient(180deg, #ffffff 0%, #f9fbfc 100%);
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .post-detail-comment:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
        }
        .post-detail-comment .comment {
            display: flex;
            gap: 12px;
        }
        .post-detail-comment .avatar {
            width: 40px;
            height: 40px;
        }
        .post-detail-comment .comment-content {
            flex: 1;
        }
        .post-detail-comment .author-name {
            font-weight: 600;
            color: var(--secondary);
            cursor: pointer;
        }
        .post-detail-comment .author-name:hover {
            color: var(--primary);
            text-decoration: underline;
        }
        .post-detail-comment .comment-text {
            font-size: 1em;
            line-height: 1.6;
            color: var(--secondary);
            margin-bottom: 5px;
        }
        .post-detail-comment .comment-meta {
            display: flex;
            gap: 15px;
            font-size: 0.9em;
            color: #7f8c8d;
        }
        .post-detail-comment .action-btn {
            background: none;
            border: none;
            color: #7f8c8d;
            cursor: pointer;
            transition: color 0.2s, transform 0.2s;
        }
        .post-detail-comment .action-btn:hover {
            color: var(--primary);
            transform: scale(1.1);
        }
        .comment-form {
            display: flex;
            gap: 10px;
            margin-top: 20px;
            background: #f9fbfc;
            padding: 15px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        .comment-form .avatar {
            width: 40px;
            height: 40px;
        }
        .comment-form textarea {
            flex: 1;
            padding: 12px;
            border: 1.5px solid #eaf1ff;
            border-radius: 10px;
            font-size: 1em;
            resize: none;
            min-height: 50px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .comment-form textarea:focus {
            border-color: var(--primary);
            box-shadow: 0 0 10px rgba(79, 140, 255, 0.2);
        }
        .comment-form .btn-primary {
            padding: 10px 20px;
            border-radius: 10px;
            font-size: 1em;
            transition: all 0.3s ease;
        }
        .comment-form .btn-primary:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 15px rgba(79, 140, 255, 0.3);
        }
        .post-detail-footer {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #f0f2f5;
        }
        .related-posts {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        .related-post {
            display: flex;
            gap: 15px;
            padding: 15px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .related-post:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }
        .related-post img {
            width: 80px;
            height: 80px;
            border-radius: 8px;
            object-fit: cover;
        }
        .related-post .related-post-content {
            flex: 1;
        }
        .related-post .related-post-title {
            font-size: 1em;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 5px;
        }
        .related-post .related-post-meta {
            font-size: 0.85em;
            color: #7f8c8d;
        }
        @media (max-width: 1200px) {
            .sidebar-right {
                display: none;
            }
        }
        @media (max-width: 900px) {
            .sidebar-left {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }
            .sidebar-left.active {
                transform: translateX(0);
            }
            .main-content {
                margin-left: 0;
            }
        }
        @media (max-width: 600px) {
            .topbar {
                padding: 0 15px;
            }
            .main-content {
                padding: 20px 15px;
            }
            .post-card {
                flex-direction: column;
            }
            .post-card .post-image {
                width: 100%;
                max-height: 150px;
            }
            .post-card .post-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .post-card .post-tags {
                margin-left: 0;
                margin-top: 10px;
            }
            .post-card .post-actions {
                justify-content: space-between;
            }
            .post-detail-modal .modal {
                max-width: 95%;
                border-radius: 12px;
            }
            .post-detail-title {
                font-size: 1.5rem;
            }
            .post-detail-image {
                max-height: 250px;
            }
            .post-detail-header-top {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            .post-detail-author {
                width: 100%;
            }
            .post-detail-options {
                align-self: flex-end;
            }
            .post-detail-interaction-bar {
                flex-direction: column;
                gap: 10px;
                align-items: flex-start;
            }
            .modal-body {
                padding: 20px;
            }
            .comment-form {
                flex-direction: column;
                align-items: flex-start;
            }
            .comment-form .avatar {
                display: none;
            }
            .comment-form .btn-primary {
                align-self: flex-end;
            }
        }
    </style>
</head>
<body>
    <div class="topbar">
        <div class="logo">
            <div class="logo-icon">
                <img src="<%= request.getContextPath() %>/assets/img/logo.png" alt="Logo" class="logo-img" />
            </div>
            Diễn Đàn Luyện Thi JLPT
        </div>
        <nav class="nav">
            <a href="<%= request.getContextPath() %>/"><i class="fas fa-home"></i> Trang Chủ</a>
            <a href="<%= request.getContextPath() %>/contact"><i class="fas fa-phone"></i> Liên Hệ</a>
            <div class="account-dropdown" id="accountDropdown">
                <button class="account-btn" onclick="toggleDropdown(event)">
                    <div class="avatar sm">
                        <img src="<%= request.getContextPath() %>/assets/img/avatar.png" alt="Avatar" />
                    </div>
                    <%= escapeHtml((String) request.getAttribute("username")) %> <i class="fas fa-caret-down"></i>
                </button>
                <div class="dropdown-menu">
                    <% 
                        String username = (String) request.getAttribute("username");
                        if ("Guest".equals(username)) {
                    %>
                        <a href="<%= request.getContextPath() %>/login"><i class="fas fa-sign-in-alt"></i> Đăng Nhập</a>
                    <% 
                        } else {
                    %>
                        <a href="<%= request.getContextPath() %>/profile"><i class="fas fa-user"></i> Hồ Sơ Cá Nhân</a>
                        <a href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a>
                    <% 
                        }
                    %>
                </div>
            </div>
        </nav>
    </div>
    <div class="layout">
        <aside class="sidebar-left">
            <div class="topics">
                <div class="topics-title">Chủ Đề Thảo Luận</div>
                <ul class="topic-list">
                    <li><a href="#" data-filter="all" class="active"><i class="fas fa-star"></i> Tất Cả</a></li>
                    <li><a href="#" data-filter="N5"><i class="fas fa-star"></i> JLPT N5</a></li>
                    <li><a href="#" data-filter="N4"><i class="fas fa-star"></i> JLPT N4</a></li>
                    <li><a href="#" data-filter="N3"><i class="fas fa-star"></i> JLPT N3</a></li>
                    <li><a href="#" data-filter="N2"><i class="fas fa-star"></i> JLPT N2</a></li>
                    <li><a href="#" data-filter="N1"><i class="fas fa-star"></i> JLPT N1</a></li>
                    <li><a href="#" data-filter="Ngữ pháp"><i class="fas fa-language"></i> Ngữ Pháp</a></li>
                    <li><a href="#" data-filter="Kinh nghiệm thi"><i class="fas fa-lightbulb"></i> Kinh Nghiệm Thi</a></li>
                    <li><a href="#" data-filter="Tài liệu"><i class="fas fa-book"></i> Tài Liệu</a></li>
                    <li><a href="#" data-filter="Công cụ"><i class="fas fa-tools"></i> Công Cụ</a></li>
                </ul>
            </div>
        </aside>
        <main class="main-content">
            <% 
                String message = (String) session.getAttribute("message");
                if (message != null && !message.isEmpty()) {
            %>
                <div class="alert alert-success">
                    <%= escapeHtml(message) %>
                </div>
                <% 
                    session.removeAttribute("message");
                }
            %>
            <div class="forum-toolbar">
                <h1>Bài Viết Mới Nhất</h1>
                <div class="toolbar-actions">
                    <button class="btn btn-primary" onclick="openPostModal()">
                        <i class="fas fa-plus"></i> Tạo Bài Viết Mới
                    </button>
                    <div class="filters">
                        <select id="sortSelect" onchange="handleSortChange()">
                            <option value="newest" <%= "newest".equals(request.getAttribute("sort")) ? "selected" : "" %>>Mới Nhất</option>
                            <option value="popular" <%= "popular".equals(request.getAttribute("sort")) ? "selected" : "" %>>Phổ Biến</option>
                            <option value="most-liked" <%= "most-liked".equals(request.getAttribute("sort")) ? "selected" : "" %>>Được Thích Nhiều</option>
                        </select>
                        <select id="filterSelect" onchange="handleFilterChange()">
                            <option value="all" <%= "all".equals(request.getAttribute("filter")) ? "selected" : "" %>>Tất Cả</option>
                            <option value="with-replies" <%= "with-replies".equals(request.getAttribute("filter")) ? "selected" : "" %>>Có Phản Hồi</option>
                            <option value="no-replies" <%= "no-replies".equals(request.getAttribute("filter")) ? "selected" : "" %>>Chưa Có Phản Hồi</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="post-list">
                <% 
                    List<ForumPost> posts = (List<ForumPost>) request.getAttribute("posts");
                    String userId = (String) request.getSession().getAttribute("userId");
                    ForumPostDAO postDAO = new ForumPostDAO();
                    if (posts == null || posts.isEmpty()) {
                %>
                    <p>Chưa có bài viết nào.</p>
                <% 
                    } else {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        for (ForumPost post : posts) {
                            String postPicture = post.getPicture() != null ? post.getPicture() : "";
                            Timestamp createdDate = post.getCreatedDate();
                            String formattedDate = createdDate != null ? sdf.format(createdDate) : "";
                            boolean hasLiked = userId != null && postDAO.hasUserLikedPost(post.getId(), userId);
                %>
                    <div class="post-card" data-tags="<%= escapeHtml(post.getCategory()) %>">
                        <div class="post-image">
                            <% if (!postPicture.isEmpty()) { %>
                                <img src="<%= request.getContextPath() %>/<%= escapeHtml(postPicture) %>" alt="Post image" />
                            <% } else { %>
                                <img src="<%= request.getContextPath() %>/assets/images/home.jpg" alt="Default image" />
                            <% } %>
                        </div>
                        <div class="post-content">
                            <div class="post-header">
                                <div class="avatar">
                                    <img src="<%= request.getContextPath() %>/assets/images/avatar<%= escapeHtml(post.getPostedBy()) %>.png" alt="Avatar" />
                                </div>
                                <div class="author-info">
                                    <span class="author-name"><%= escapeHtml(new UserDAO().getUsernameByUserID(post.getPostedBy())) %></span>
                                    <div class="post-meta">
                                        <span><i class="fas fa-clock"></i> <%= formattedDate %></span>
                                        <span><i class="fas fa-eye"></i> <%= post.getViewCount() %></span>
                                        <span><i class="fas fa-comment"></i> <%= post.getCommentCount() %></span>
                                    </div>
                                </div>
                                <div class="post-tags">
                                    <span class="tag"><%= escapeHtml(post.getCategory()) %></span>
                                </div>
                            </div>
                            <div class="post-title" onclick="openPostDetailModal(<%= post.getId() %>)"><%= escapeHtml(post.getTitle()) %></div>
                            <div class="post-body">
                                <p><%= escapeHtml(post.getContent()) %></p>
                            </div>
                            <div class="post-actions">
                                <button class="action-btn like-btn <%= hasLiked ? "liked" : "" %>" onclick="toggleLike(<%= post.getId() %>, this)">
                                    <i class="fas fa-thumbs-up"></i> <span class="like-count"><%= post.getVoteCount() %></span>
                                </button>
                                <button class="action-btn comment-btn" onclick="openCommentSection(<%= post.getId() %>)">
                                    <i class="fas fa-comment"></i> <%= post.getCommentCount() %>
                                </button>
                                <button class="action-btn share-btn" onclick="sharePost(<%= post.getId() %>)">
                                    <i class="fas fa-share"></i> Chia sẻ
                                </button>
                            </div>
                            <div class="comment-section" id="comment-section-<%= post.getId() %>" style="display:none;">
                                <% 
                                    List<ForumComment> comments = post.getComments();
                                    if (comments != null) {
                                        for (ForumComment comment : comments) {
                                            Timestamp commentDate = comment.getCommentedDate();
                                            String formattedCommentDate = commentDate != null ? sdf.format(commentDate) : "";
                                %>
                                    <div class="comment">
                                        <div class="avatar">
                                            <img src="<%= request.getContextPath() %>/assets/images/avatar.png" alt="Avatar" />
                                        </div>
                                        <div class="comment-content">
                                            <span class="author-name"><%= escapeHtml(new UserDAO().getUsernameByUserID(comment.getCommentedBy())) %></span>
                                            <p><%= escapeHtml(comment.getCommentText()) %></p>
                                            <span class="comment-time"><i class="fas fa-clock"></i> <%= formattedCommentDate %></span>
                                            <button class="action-btn">
                                                <i class="fas fa-thumbs-up"></i> <%= comment.getVoteCount() %>
                                            </button>
                                        </div>
                                    </div>
                                <% 
                                        }
                                    }
                                %>
                                <form action="<%= request.getContextPath() %>/forum/createComment" method="post" class="comment-form">
                                    <input type="hidden" name="postId" value="<%= post.getId() %>">
                                    <textarea name="commentText" placeholder="Viết bình luận..." required></textarea>
                                    <button type="submit" class="btn btn-primary">Gửi</button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% 
                        }
                    }
                %>
            </div>
            <div class="pagination">
                <% 
                    Integer pageNum = (Integer) request.getAttribute("page");
                    String sort = (String) request.getAttribute("sort");
                    String filter = (String) request.getAttribute("filter");
                    if (pageNum != null && pageNum > 1) {
                %>
                    <a href="<%= request.getContextPath() %>/forum?sort=<%= escapeHtml(sort) %>&filter=<%= escapeHtml(filter) %>&page=<%= pageNum - 1 %>">« Trang Trước</a>
                <% 
                    }
                    if (posts != null && !posts.isEmpty()) {
                %>
                    <a href="<%= request.getContextPath() %>/forum?sort=<%= escapeHtml(sort) %>&filter=<%= escapeHtml(filter) %>&page=<%= pageNum != null ? pageNum + 1 : 2 %>">Trang Sau »</a>
                <% 
                    }
                %>
            </div>
        </main>
        <aside class="sidebar-right">
            <div class="widget">
                <h3 class="widget-title"><i class="fas fa-trophy"></i> Top Tương Tác</h3>
                <ul class="top-users">
                    <% 
                        List<UserActivityScore> topUsers = (List<UserActivityScore>) request.getAttribute("topUsers");
                        if (topUsers != null) {
                            int rank = 1;
                            for (UserActivityScore score : topUsers) {
                                User user = score.getUser();
                                if (user != null) {
                                    String profilePicture = user.getProfilePicture() != null ? user.getProfilePicture() : "";
                    %>
                    <li class="top-user">
                        <div class="rank"><%= rank++ %></div>
                        <div class="avatar">
                            <img src="<%= request.getContextPath() %>/<%= profilePicture != null && !profilePicture.isEmpty() ? escapeHtml(profilePicture) : "assets/img/avatar.jpg" %>" alt="Avatar" />
                        </div>
                        <div class="user-info">
                            <div class="user-name"><%= escapeHtml(user.getUsername()) %></div>
                            <div class="user-role"><%= escapeHtml(user.getRole()) %></div>
                            <div class="user-points"><%= score.getTotalComments() %> bình luận, <%= score.getTotalVotes() %> lượt thích</div>
                        </div>
                    </li>
                    <% 
                                }
                            }
                        }
                    %>
                </ul>
            </div>
            <div class="widget">
                <h3 class="widget-title"><i class="fas fa-link"></i> Liên Kết Nhanh</h3>
                <button class="btn btn-blue btn-block"><i class="fas fa-book"></i> Từ Vựng Hôm Nay</button>
                <button class="btn btn-yellow btn-block"><i class="fas fa-language"></i> Ngữ Pháp Cơ Bản</button>
                <button class="btn btn-primary btn-block"><i class="fas fa-check"></i> Kiểm Tra Trình Độ</button>
            </div>
            <div class="widget">
                <div class="widget-image">
                    <img src="<%= request.getContextPath() %>/assets/img/backgroundLogin.png" alt="Image" />
                </div>
            </div>
        </aside>
    </div>
    <div class="modal-overlay" id="createPostModal">
        <div class="modal">
            <div class="modal-header">
                <h2 class="modal-title">Tạo Bài Viết Mới</h2>
                <button class="btn" onclick="closePostModal()"><i class="fas fa-times"></i></button>
            </div>
            <div class="modal-body">
                <form id="createPostForm" action="<%= request.getContextPath() %>/forum/createPost" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label class="form-label" for="postTitle">Tiêu đề</label>
                        <input type="text" class="form-control" id="postTitle" name="postTitle" placeholder="Nhập tiêu đề bài viết..." required />
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="postCategory">Chủ đề</label>
                        <select class="form-control" id="postCategory" name="postCategory" required>
                            <option value="">Chọn chủ đề</option>
                            <option value="N5">JLPT N5</option>
                            <option value="N4">JLPT N4</option>
                            <option value="N3">JLPT N3</option>
                            <option value="N2">JLPT N2</option>
                            <option value="N1">JLPT N1</option>
                            <option value="Ngữ pháp">Ngữ Pháp</option>
                            <option value="Kinh nghiệm thi">Kinh Nghiệm Thi</option>
                            <option value="Tài liệu">Tài Liệu</option>
                            <option value="Công cụ">Công Cụ</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="postContent">Nội Dung</label>
                        <textarea class="form-control" id="postContent" name="postContent" rows="6" placeholder="Nhập nội dung bài viết..." required></textarea>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Hình Ảnh</label>
                        <div class="image-upload" onclick="document.getElementById('imageInput').click()">
                            <input type="file" id="imageInput" name="imageInput" accept="image/*" onchange="previewImage(event)" />
                            <i class="fas fa-cloud-upload-alt" style="font-size: 2em; margin-bottom: 10px"></i>
                            <p>Nhấp để chọn hình ảnh hoặc kéo thả vào đây</p>
                            <img id="imagePreview" class="image-preview" style="display:none;" alt="Preview" />
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" onclick="document.getElementById('createPostForm').submit()">Đăng Bài</button>
                <button class="btn" onclick="closePostModal()">Đóng</button>
            </div>
        </div>
    </div>
    <!-- Post Detail Modal -->
    <%
        if (posts != null && !posts.isEmpty()) {
            for (ForumPost post : posts) {
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                String postPicture = post.getPicture() != null ? post.getPicture() : "";
                Timestamp createdDate = post.getCreatedDate();
                String formattedDate = createdDate != null ? sdf.format(createdDate) : "";
                boolean hasLiked = userId != null && postDAO.hasUserLikedPost(post.getId(), userId);
                boolean isAuthor = userId != null && post.getPostedBy().equals(userId);
    %>
    <div class="modal-overlay post-detail-modal" id="post-detail-modal-<%= post.getId() %>">
        <div class="modal">
            <div class="modal-body">
                <div class="post-detail-header">
                    <div class="post-detail-header-top">
                        <div class="post-detail-author">
                            <div class="avatar">
                                <img src="<%= request.getContextPath() %>/assets/images/avatar<%= escapeHtml(post.getPostedBy()) %>.png" alt="Avatar" />
                            </div>
                            <div class="post-detail-author-info">
                                <a href="<%= request.getContextPath() %>/profile?userId=<%= escapeHtml(post.getPostedBy()) %>" class="post-detail-author-name">
                                    <%= escapeHtml(new UserDAO().getUsernameByUserID(post.getPostedBy())) %>
                                </a>
                                <span class="post-detail-time"><i class="fas fa-clock"></i> <%= formattedDate %></span>
                            </div>
                        </div>
                        <div class="post-detail-options" id="options-<%= post.getId() %>">
                            <button class="post-detail-options-btn" onclick="toggleOptions(<%= post.getId() %>)">
                                <i class="fas fa-ellipsis-v"></i>
                            </button>
                            <div class="post-detail-options-menu">
                                <% if (isAuthor) { %>
                                    <a href="<%= request.getContextPath() %>/forum/editPost?postId=<%= post.getId() %>">Chỉnh sửa</a>
                                    <button onclick="deletePost(<%= post.getId() %>)">Xóa</button>
                                <% } %>
                                <button onclick="reportPost(<%= post.getId() %>)">Báo cáo</button>
                            </div>
                        </div>
                    </div>
                    <div class="post-detail-title"><%= escapeHtml(post.getTitle()) %></div>
                </div>
                <div class="post-detail-content">
                    <p>
                        <% 
                            String content = post.getContent();
                            String[] words = content.split("\\s+");
                            for (String word : words) {
                                if (word.startsWith("#")) {
                        %>
                            <a href="<%= request.getContextPath() %>/forum?tag=<%= escapeHtml(word.substring(1)) %>" class="hashtag"><%= escapeHtml(word) %></a>
                        <% 
                                } else {
                        %>
                            <%= escapeHtml(word) %>
                        <% 
                                }
                            }
                        %>
                    </p>
                    <div class="post-detail-image <%= postPicture.isEmpty() ? "placeholder" : "" %>">
                        <% if (!postPicture.isEmpty()) { %>
                            <img src="<%= request.getContextPath() %>/<%= escapeHtml(postPicture) %>" alt="Post image" />
                        <% } else { %>
                            Không có hình ảnh
                        <% } %>
                    </div>
                </div>
                <div class="post-detail-interaction-bar">
                    <div class="post-detail-interaction-stats">
                        <span><i class="fas fa-thumbs-up"></i> <%= post.getVoteCount() %> lượt thích</span>
                        <span> • </span>
                        <span><i class="fas fa-comment"></i> <%= post.getCommentCount() %> bình luận</span>
                        <span> • </span>
                        <span><i class="fas fa-share"></i> 0 chia sẻ</span>
                    </div>
                    <div class="post-detail-interaction-buttons">
                        <button class="action-btn like-btn <%= hasLiked ? "liked" : "" %>" onclick="toggleLike(<%= post.getId() %>, this)">
                            <i class="fas fa-thumbs-up"></i> Thích
                        </button>
                        <button class="action-btn comment-btn" onclick="focusComment(<%= post.getId() %>)">
                            <i class="fas fa-comment"></i> Bình luận
                        </button>
                        <button class="action-btn share-btn" onclick="sharePost(<%= post.getId() %>)">
                            <i class="fas fa-share"></i> Chia sẻ
                        </button>
                    </div>
                </div>
                <div class="post-detail-comment-section">
                    <% 
                        List<ForumComment> comments = post.getComments();
                        if (comments != null) {
                            for (ForumComment comment : comments) {
                                Timestamp commentDate = comment.getCommentedDate();
                                String formattedCommentDate = commentDate != null ? sdf.format(commentDate) : "";
                    %>
                        <div class="post-detail-comment">
                            <div class="comment">
                                <div class="avatar">
                                    <img src="<%= request.getContextPath() %>/assets/images/avatar.png" alt="Avatar" />
                                </div>
                                <div class="comment-content">
                                    <a href="<%= request.getContextPath() %>/profile?userId=<%= escapeHtml(comment.getCommentedBy()) %>" class="author-name">
                                        <%= escapeHtml(new UserDAO().getUsernameByUserID(comment.getCommentedBy())) %>
                                    </a>
                                    <p class="comment-text"><%= escapeHtml(comment.getCommentText()) %></p>
                                    <div class="comment-meta">
                                        <span class="comment-time"><i class="fas fa-clock"></i> <%= formattedCommentDate %></span>
                                        <button class="action-btn">
                                            <i class="fas fa-thumbs-up"></i> <%= comment.getVoteCount() %>
                                        </button>
                                        <button class="action-btn" onclick="replyComment(<%= comment.getId() %>)">
                                            <i class="fas fa-reply"></i> Phản hồi
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% 
                            }
                        }
                    %>
                    <form action="<%= request.getContextPath() %>/forum/createComment" method="post" class="comment-form" id="comment-form-<%= post.getId() %>">
                        <div class="avatar">
                            <img src="<%= request.getContextPath() %>/assets/images/avatar.png" alt="Avatar" />
                        </div>
                        <input type="hidden" name="postId" value="<%= post.getId() %>">
                        <textarea name="commentText" placeholder="Viết bình luận..." required></textarea>
                        <button type="submit" class="btn btn-primary">Gửi</button>
                    </form>
                </div>
                <div class="post-detail-footer">
                    <h3 style="font-size: 1.2em; color: var(--primary); margin-bottom: 15px;">Bài viết liên quan</h3>
                    <div class="related-posts">
                        <div class="related-post">
                            <img src="<%= request.getContextPath() %>/assets/images/sample_post1.jpg" alt="Related post" />
                            <div class="related-post-content">
                                <div class="related-post-title">Mẹo học từ vựng JLPT N3 hiệu quả</div>
                                <div class="related-post-meta">bởi User123 • 10/06/2025</div>
                            </div>
                        </div>
                        <div class="related-post">
                            <img src="<%= request.getContextPath() %>/assets/images/sample_post2.jpg" alt="Related post" />
                            <div class="related-post-content">
                                <div class="related-post-title">Tài liệu ôn thi JLPT N2 miễn phí</div>
                                <div class="related-post-meta">bởi User456 • 08/06/2025</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn" onclick="closePostDetailModal(<%= post.getId() %>)">Đóng</button>
            </div>
        </div>
    </div>
    <% 
            }
        }
    %>
    <script>
        function toggleDropdown(e) {
            e.stopPropagation();
            document.getElementById("accountDropdown").classList.toggle("open");
        }
        document.body.addEventListener("click", function() {
            document.getElementById("accountDropdown").classList.remove("open");
        });
        function openPostModal() {
            document.getElementById("createPostModal").classList.add("active");
        }
        function closePostModal() {
            document.getElementById("createPostModal").classList.remove("active");
        }
        function previewImage(event) {
            const file = event.target.files[0];
            const preview = document.getElementById("imagePreview");
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = "block";
                };
                reader.readAsDataURL(file);
            }
        }
        function openCommentSection(postId) {
            const section = document.getElementById("comment-section-" + postId);
            section.style.display = section.style.display === "none" ? "block" : "none";
        }
        function openPostDetailModal(postId) {
            const modal = document.getElementById("post-detail-modal-" + postId);
            modal.classList.add("active");
            fetch("<%= request.getContextPath() %>/forum/incrementView?postId=" + postId, {
                method: "POST"
            });
        }
        function closePostDetailModal(postId) {
            const modal = document.getElementById("post-detail-modal-" + postId);
            modal.classList.remove("active");
        }
        function handleSortChange() {
            const sortValue = document.getElementById("sortSelect").value;
            window.location.href = "<%= request.getContextPath() %>/forum?sort=" + encodeURIComponent(sortValue) + "&filter=<%= escapeHtml((String) request.getAttribute("filter")) %>&page=<%= request.getAttribute("page") %>";
        }
        function handleFilterChange() {
            const filterValue = document.getElementById("filterSelect").value;
            window.location.href = "<%= request.getContextPath() %>/forum?sort=<%= escapeHtml((String) request.getAttribute("sort")) %>&filter=" + encodeURIComponent(filterValue) + "&page=<%= request.getAttribute("page") %>";
        }
        function toggleLike(postId, button) {
            const userId = "<%= userId != null ? userId : "" %>";
            if (!userId) {
                alert("Vui lòng đăng nhập để thích bài viết!");
                window.location.href = "<%= request.getContextPath() %>/login";
                return;
            }
            const isLiked = button.classList.contains("liked");
            const url = "<%= request.getContextPath() %>/forum/toggleLike";
            fetch(url, {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: "postId=" + postId + "&action=" + (isLiked ? "unlike" : "like")
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const likeCountSpan = button.querySelector(".like-count");
                    likeCountSpan.textContent = data.voteCount;
                    if (isLiked) {
                        button.classList.remove("liked");
                    } else {
                        button.classList.add("liked");
                    }
                    // Update interaction stats in modal
                    const stats = document.querySelector(`#post-detail-modal-${postId} .post-detail-interaction-stats`);
                    if (stats) {
                        stats.querySelector("span:first-child").innerHTML = `<i class="fas fa-thumbs-up"></i> ${data.voteCount} lượt thích`;
                    }
                } else {
                    alert(data.message || "Có lỗi xảy ra khi thích bài viết!");
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert("Có lỗi xảy ra khi thích bài viết!");
            });
        }
        function toggleOptions(postId) {
            const options = document.getElementById(`options-${postId}`);
            options.classList.toggle("open");
        }
        function deletePost(postId) {
            if (confirm("Bạn có chắc muốn xóa bài viết này?")) {
                window.location.href = "<%= request.getContextPath() %>/forum/deletePost?postId=" + postId;
            }
        }
        function reportPost(postId) {
            alert("Chức năng báo cáo đang được phát triển!");
        }
        function sharePost(postId) {
            alert("Chức năng chia sẻ đang được phát triển!");
        }
        function focusComment(postId) {
            const textarea = document.querySelector(`#comment-form-${postId} textarea`);
            textarea.focus();
        }
        function replyComment(commentId) {
            alert("Chức năng phản hồi bình luận đang được phát triển!");
        }
        document.querySelectorAll(".topic-list a").forEach(function(link) {
            link.addEventListener("click", function(e) {
                e.preventDefault();
                const topic = link.getAttribute("data-filter");
                document.querySelectorAll(".topic-list a").forEach(function(l) {
                    l.classList.remove("active");
                });
                link.classList.add("active");
                const posts = document.querySelectorAll(".post-card");
                posts.forEach(function(post) {
                    const tags = post.getAttribute("data-tags");
                    if (topic === "all" || tags === topic) {
                        post.style.display = "flex";
                    } else {
                        post.style.display = "none";
                    }
                });
            });
        });
        document.getElementById("createPostModal").addEventListener("click", function(e) {
            if (e.target === this) {
                closePostModal();
            }
        });
        document.querySelectorAll(".post-detail-modal").forEach(function(modal) {
            modal.addEventListener("click", function(e) {
                if (e.target === this) {
                    const postId = this.id.replace("post-detail-modal-", "");
                    closePostDetailModal(postId);
                }
            });
        });
        document.addEventListener("click", function(e) {
            document.querySelectorAll(".post-detail-options.open").forEach(function(options) {
                if (!options.contains(e.target)) {
                    options.classList.remove("open");
                }
            });
        });
        function toggleMobileMenu() {
            document.querySelector(".sidebar-left").classList.toggle("active");
        }
        document.querySelector('.topic-list a[data-filter="all"]').click();
    </script>
    <%@include file="chatbox.jsp" %>
</body>
</html>