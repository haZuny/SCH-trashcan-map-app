from django.shortcuts import render

from typing import ByteString
from django.shortcuts import render
from rest_framework.response import Response
from .models import Posting
from rest_framework.views  import APIView
from .serializers import PostingSerializer
from django.http import Http404

import io   # 이미지 관련
import os
from django.core.files import File
from django.http import FileResponse

import chardet
import base64

import json

# Create your views here.

# 전체 게시물
class PostingList(APIView):
    def post(self, request):
        serializer = PostingSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors)

    def get(self, request):
        quryset = Posting.objects.all()
        serizer = PostingSerializer(quryset, many=True)

        # 전송할 데이터 가공
        sendData = []
        for obj in serizer.data:
            newObj = {} # 최종적으로 보낼 객체
            for key, value in obj.items():
                # if(key != 'image'):
                    # f = open('.'+obj['image'], 'rb')
                    # newObj[key] = ''+ str(f.read())
                newObj[key] = value
                # else:
            sendData.append(newObj)
    
        return Response(sendData)
        

# 특정 게시물
class PostingDetail(APIView):
    def get_object(self, pk):
        try:
            return Posting.objects.get(pk=pk)
        except Posting.DoesNotExist:
            raise Http404


    def get(self, request, pk):
        posting = self.get_object(pk)
        seriizer = PostingSerializer(posting)
        
        # get
        if request.method == "GET":

            sendData = []
            obj = {}
            for key in seriizer.data:
                obj[key] = seriizer.data[key]
            sendData.append(obj)

            return Response(sendData)

        elif request.method == "HEAD":
            posting.delete()
            return Response()

        elif request.method == "OPTIONS":
            print("asdf")
            print(request.data)
            updatePosting = PostingSerializer(posting, data=request.data)
            if updatePosting.is_valid():
                updatePosting.save()
                return Response(updatePosting.data)
            return Response(serializer.errors)
    
    def delete(self, request, pk):
        