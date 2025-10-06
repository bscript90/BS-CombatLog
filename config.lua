Settings = {
    Language = "en",
    Locale = {
        tr = {
            copied = "Çıkış yapan oyuncunun bilgileri kopyalandı!",
            combatLogText = "[${playerId}] ${playerName} oyundan ayrıldı. Sebep: ${reason}\nSaat: ${time}\n${identifiers}",
        },
        en = {
            copied = "The information of the exiting player has been copied!",
            combatLogText = "[${playerId}] ${playerName} left the game. Reason: ${reason}\nTime: ${time}\n${identifiers}",
        },
        de = {
            copied = "Die Informationen des aussteigenden Spielers wurden kopiert!",
            combatLogText = "[${playerId}] ${playerName} hat das Spiel verlassen. Grund: ${reason}\nZeit: ${time}\n${identifiers}",
        },
    },
    ShowICName = true, -- Show IC Name, IF false show Steam/CFX Name
    Identifiers = {
        discord = true, -- Show Player Discord ID
        steam = true, -- Show Player Steam ID
    },
    ShowPed = true, -- Should the player's ped be visible?
    DeletionPeriod = 5 -- How many minutes later should it be deleted?
}