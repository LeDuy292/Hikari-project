package model;

import java.time.LocalDateTime;

public class SearchHistory {
    private int id;
    private String keyword;
    private LocalDateTime searchTime;
    private String userIdentifier;

    public SearchHistory() {
    }

    public SearchHistory(String keyword, String userIdentifier) {
        this.keyword = keyword;
        this.userIdentifier = userIdentifier;
    }

    public SearchHistory(int id, String keyword, LocalDateTime searchTime, String userIdentifier) {
        this.id = id;
        this.keyword = keyword;
        this.searchTime = searchTime;
        this.userIdentifier = userIdentifier;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public LocalDateTime getSearchTime() {
        return searchTime;
    }

    public void setSearchTime(LocalDateTime searchTime) {
        this.searchTime = searchTime;
    }

    public String getUserIdentifier() {
        return userIdentifier;
    }

    public void setUserIdentifier(String userIdentifier) {
        this.userIdentifier = userIdentifier;
    }
}