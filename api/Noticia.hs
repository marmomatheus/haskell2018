{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
module Noticia where

import Foundation
import Yesod
import Database.Persist.Postgresql
import Data.Text
import Network.HTTP.Types.Status

-- Cadastra 1 Noticia
postNoticiaCriarR :: Handler ()
postNoticiaCriarR = do
    pers <- requireJsonBody :: Handler Noticia
    pid <- runDB $ insert pers
    sendResponse (object [pack "resp" .= pack ("CREATED " ++ (show $ fromSqlKey pid))])

-- Lista todos os Noticiaes
getNoticiaListarR :: Handler Value
getNoticiaListarR = do
    pers <- runDB $ selectList [] [Asc NoticiaTitulo]
    sendResponse (object [pack "resp" .= toJSON pers])

-- Recebe 1 Noticia
getNoticiaGetR :: NoticiaId -> Handler Value
getNoticiaGetR pid = do
    pers <- runDB $ get404 pid
    sendStatusJSON ok200 (object ["resp" .= pers])

-- Deleta 1 Noticia
deleteNoticiaDeleteR :: NoticiaId -> Handler Value
deleteNoticiaDeleteR pid = do
	_ <- runDB $ get404 pid
	runDB $ delete pid
	sendStatusJSON noContent204 (object [])