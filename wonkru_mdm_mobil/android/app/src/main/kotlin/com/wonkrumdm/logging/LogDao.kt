package com.wonkrumdm.logging

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query

@Dao
interface LogDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(entry: LogEntry)

    @Query("SELECT * FROM wonkru_logs WHERE synced = 0 AND level >= :minLevel ORDER BY timestamp ASC")
    suspend fun getUnsynced(minLevel: Int): List<LogEntry>

    @Query("UPDATE wonkru_logs SET synced = 1 WHERE id IN (:ids)")
    suspend fun markSynced(ids: List<String>)

    @Query("DELETE FROM wonkru_logs WHERE synced = 1 AND timestamp < :before")
    suspend fun deleteOldSynced(before: String)

    @Query("SELECT COUNT(*) FROM wonkru_logs")
    suspend fun count(): Int

    @Query("""
        DELETE FROM wonkru_logs WHERE id IN (
            SELECT id FROM wonkru_logs WHERE synced = 1
            ORDER BY timestamp ASC LIMIT :count
        )
    """)
    suspend fun deleteOldestSynced(count: Int): Int

    @Query("""
        DELETE FROM wonkru_logs WHERE id IN (
            SELECT id FROM wonkru_logs WHERE synced = 0
            ORDER BY timestamp ASC LIMIT :count
        )
    """)
    suspend fun deleteOldestUnsynced(count: Int): Int

    @Query("DELETE FROM wonkru_logs")
    suspend fun deleteAll()

    @Query("SELECT * FROM wonkru_logs WHERE level >= :minLevel ORDER BY timestamp DESC LIMIT :limit")
    suspend fun getRecent(minLevel: Int, limit: Int): List<LogEntry>
}